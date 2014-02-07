Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaBGPEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:04:48 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45992 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBGPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:04:46 -0500
Date: Fri, 7 Feb 2014 16:04:34 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, vijay.a.purushothaman@intel.com,
        airlied@linux.ie, daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com,
        tomi.valkeinen@ti.com, airlied@redhat.com, robdclark@gmail.com,
        archit@ti.com, gregkh@linuxfoundation.org, joe@perches.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/11] Enabling 180 degree rotation for sprite and
 crtc planes
Message-ID: <20140207150434.GA17001@phenom.ffwll.local>
Mail-Followup-To: sagar.a.kamble@intel.com, intel-gfx@lists.freedesktop.org,
	vijay.a.purushothaman@intel.com, airlied@linux.ie,
	jani.nikula@linux.intel.com, tomi.valkeinen@ti.com,
	airlied@redhat.com, robdclark@gmail.com, archit@ti.com,
	gregkh@linuxfoundation.org, joe@perches.com,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 07:15:05PM +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> These patches will enable 180 degree rotation for CRTC and Sprite planes.
> Changelog:
> 1. drm/i915: Add 180 degree primary plane rotation support
> Addressed review comments for CRTC rotation from FBC, page flip, CRTC active/
> inactive perspective.
> 2. drm/i915: Calling rotate and inverse rotate transformations after
>     clipping
> Moved drm_rect_rotate below clip operation in intel_update_plane. Added 
> rotate and inverse rotate transforms for dest rect as well.
> 3. drm: Add drm_mode_create_rotation_property()
> Fixed bug in drm_mode_create_rotation_property to create entries only for
> supported rotations.

Clarification wrt cc'ing other mailing lists and driver maintainers:
You've cc'ed the entire patch series to all the lists and maintainers,
which means they'll also get patches they don't care about (like the i915
patches at the end), adding to the overall noise levels.

Best practice is to run the scripts/get_maintainers.pl tool for each
non-i915 patch individually and then add the additional Cc: lines to the
bottom of the commit message like this:

Cc: Rob Clark <robdclark@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

git send-email will then pick up the additional Cc: entries on each patch.

Cheers, Daniel

> 
> Sagar Kamble (2):
>   drm/i915: Add 180 degree primary plane rotation support
>   drm/i915: Calling rotate and inverse rotate transformations after
>     clipping
> 
> Ville Syrjälä (9):
>   drm: Move DRM_ROTATE bits out of omapdrm into drm_crtc.h
>   drm: Add support_bits parameter to drm_property_create_bitmask()
>   drm: Add drm_mode_create_rotation_property()
>   drm/omap: Switch omapdrm over to drm_mode_create_rotation_property()
>   drm: Add drm_rect rotation functions
>   drm: Add drm_rotation_simplify()
>   drm/i915: Add 180 degree sprite rotation support
>   drm/i915: Make intel_plane_restore() return an error
>   drm/i915: Add rotation property for sprites
> 
>  drivers/gpu/drm/drm_crtc.c           |  69 ++++++++++++++++-
>  drivers/gpu/drm/drm_rect.c           | 140 +++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/i915_dma.c      |  12 +++
>  drivers/gpu/drm/i915/i915_drv.h      |   1 +
>  drivers/gpu/drm/i915/i915_reg.h      |   4 +
>  drivers/gpu/drm/i915/intel_display.c |  86 ++++++++++++++++++++-
>  drivers/gpu/drm/i915/intel_drv.h     |   5 +-
>  drivers/gpu/drm/i915/intel_pm.c      |   9 +++
>  drivers/gpu/drm/i915/intel_sprite.c  | 101 +++++++++++++++++++++++--
>  drivers/gpu/drm/omapdrm/omap_drv.h   |   7 --
>  drivers/gpu/drm/omapdrm/omap_plane.c |  17 ++---
>  include/drm/drm_crtc.h               |  15 +++-
>  include/drm/drm_rect.h               |   6 ++
>  13 files changed, 440 insertions(+), 32 deletions(-)
> 
> -- 
> 1.8.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
