Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaBKWGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:06:12 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:42047 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaBKWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:06:10 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1392116390-23798-1-git-send-email-sagar.a.kamble@intel.com>
References: <1392116390-23798-1-git-send-email-sagar.a.kamble@intel.com>
Date: Tue, 11 Feb 2014 23:06:09 +0100
Message-ID: <CAKMK7uHemuNJV3oxkKEsf==jzj4sDMosoObeQC7a2CFWdocs7Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] drm/i915: Add 180 degree primary plane rotation support
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Purushothaman, Vijay A" <vijay.a.purushothaman@intel.com>,
        Uma Shankar <uma.shankar@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 11:59 AM,  <sagar.a.kamble@intel.com> wrote:
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
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Cc: vijay.a.purushothaman@intel.com
> Signed-off-by: Uma Shankar <uma.shankar@intel.com>
> Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>

Process nit: Since you have a nice testcase for this, please add a
reference to it using the testcase tag in the cc/sob section here,
e.g.

Testcase: igt/kms_plane_rotation_crc

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
