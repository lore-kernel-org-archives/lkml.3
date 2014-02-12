Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaBLOCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:02:40 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:49984 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751284AbaBLOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:02:38 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Wed, 12 Feb 2014 14:02:24 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, vijay.a.purushothaman@intel.com,
        Uma Shankar <uma.shankar@intel.com>
Subject: Re: [PATCH v6 1/1] drm/i915: Add 180 degree primary plane rotation
 support
Message-ID: <20140212140224.GB14909@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	sagar.a.kamble@intel.com, intel-gfx@lists.freedesktop.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, vijay.a.purushothaman@intel.com,
	Uma Shankar <uma.shankar@intel.com>
References: <20140211211937.GZ3891@intel.com>
 <1392187920-27870-1-git-send-email-sagar.a.kamble@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392187920-27870-1-git-send-email-sagar.a.kamble@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:22:00PM +0530, sagar.a.kamble@intel.com wrote:
> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> Primary planes support 180 degree rotation. Expose the feature
> through rotation drm property.
> 
> v2: Calculating linear/tiled offsets based on pipe source width and
> height. Added 180 degree rotation support in ironlake_update_plane.
> 
> v3: Checking if CRTC is active before issueing update_plane. Added
> wait for vblank to make sure we dont overtake page flips. Disabling
> FBC since it does not work with rotated planes.
> 
> v4: Updated rotation checks for pending flips, fbc disable. Creating
> rotation property only for Gen4 onwards. Property resetting as part
> of lastclose.
> 
> v5: Resetting property in i915_driver_lastclose properly for planes
> and crtcs. Fixed linear offset calculation that was off by 1 w.r.t
> width in i9xx_update_plane and ironlake_update_plane. Removed tab
> based indentation and unnecessary braces in intel_crtc_set_property
> and intel_update_fbc. FBC and flip related checks should be done only
> for valid crtcs.
> 
> v6: Minor nits in FBC disable checks for comments in intel_crtc_set_property
> and positioning the disable code in intel_update_fbc.
> 
> Testcase: igt/kms_plane_rotation_crc

I particularly enjoyed how it reports an error after successfully
changing rotation modes. It could use with a few DRM_DEBUG_KMS() to
highlight what is hanppening.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
