Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaBGNom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:44:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:52219 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbaBGNok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:44:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,800,1384329600"; 
   d="scan'208";a="479632547"
From: sagar.a.kamble@intel.com
To: intel-gfx@lists.freedesktop.org
Cc: vijay.a.purushothaman@intel.com, airlied@linux.ie, daniel.vetter@ffwll.ch,
        jani.nikula@linux.intel.com, tomi.valkeinen@ti.com, airlied@redhat.com,
        robdclark@gmail.com, archit@ti.com, gregkh@linuxfoundation.org,
        joe@perches.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Sagar Kamble <sagar.a.kamble@intel.com>
Subject: [PATCH v4 00/11] Enabling 180 degree rotation for sprite and crtc planes
Date: Fri,  7 Feb 2014 19:15:05 +0530
Message-Id: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
X-Mailer: git-send-email 1.8.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Kamble <sagar.a.kamble@intel.com>

These patches will enable 180 degree rotation for CRTC and Sprite planes.
Changelog:
1. drm/i915: Add 180 degree primary plane rotation support
Addressed review comments for CRTC rotation from FBC, page flip, CRTC active/
inactive perspective.
2. drm/i915: Calling rotate and inverse rotate transformations after
    clipping
Moved drm_rect_rotate below clip operation in intel_update_plane. Added 
rotate and inverse rotate transforms for dest rect as well.
3. drm: Add drm_mode_create_rotation_property()
Fixed bug in drm_mode_create_rotation_property to create entries only for
supported rotations.

Sagar Kamble (2):
  drm/i915: Add 180 degree primary plane rotation support
  drm/i915: Calling rotate and inverse rotate transformations after
    clipping

Ville Syrjälä (9):
  drm: Move DRM_ROTATE bits out of omapdrm into drm_crtc.h
  drm: Add support_bits parameter to drm_property_create_bitmask()
  drm: Add drm_mode_create_rotation_property()
  drm/omap: Switch omapdrm over to drm_mode_create_rotation_property()
  drm: Add drm_rect rotation functions
  drm: Add drm_rotation_simplify()
  drm/i915: Add 180 degree sprite rotation support
  drm/i915: Make intel_plane_restore() return an error
  drm/i915: Add rotation property for sprites

 drivers/gpu/drm/drm_crtc.c           |  69 ++++++++++++++++-
 drivers/gpu/drm/drm_rect.c           | 140 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_dma.c      |  12 +++
 drivers/gpu/drm/i915/i915_drv.h      |   1 +
 drivers/gpu/drm/i915/i915_reg.h      |   4 +
 drivers/gpu/drm/i915/intel_display.c |  86 ++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_drv.h     |   5 +-
 drivers/gpu/drm/i915/intel_pm.c      |   9 +++
 drivers/gpu/drm/i915/intel_sprite.c  | 101 +++++++++++++++++++++++--
 drivers/gpu/drm/omapdrm/omap_drv.h   |   7 --
 drivers/gpu/drm/omapdrm/omap_plane.c |  17 ++---
 include/drm/drm_crtc.h               |  15 +++-
 include/drm/drm_rect.h               |   6 ++
 13 files changed, 440 insertions(+), 32 deletions(-)

-- 
1.8.5

