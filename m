Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab3HMXXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:23:38 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40129 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3HMXXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:23:36 -0400
X-Originating-IP: 173.246.103.110
Date: Tue, 13 Aug 2013 16:23:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] i915: Add a Kconfig option to turn on
 i915.preliminary_hw_support by default
Message-ID: <20130813232130.GA20895@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building kernels for a preliminary hardware target, having to add a
kernel command-line option can prove inconvenient.  Add a Kconfig option
that changes the default of this option to 1.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

I dropped the indication of the default in the module parameter
documentation, but I could also change it to show the default for the
current kernel via ifdef.

 drivers/gpu/drm/Kconfig         | 9 +++++++++
 drivers/gpu/drm/i915/i915_drv.c | 4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index a7c54c8..35d57ed 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -168,6 +168,15 @@ config DRM_I915_KMS
 	  the driver to bind to PCI devices, which precludes loading things
 	  like intelfb.
 
+config DRM_I915_PRELIMINARY_HW_SUPPORT
+	bool "Enable preliminary support for prerelease Intel hardware by default"
+	depends on DRM_I915
+	help
+	  Choose this option if you have prerelease Intel hardware and want the
+	  i915 driver to support it by default.  You can enable such support at
+	  runtime with the module option i915.preliminary_hw_support=1; this
+	  option changes the default for that module option.
+
 config DRM_MGA
 	tristate "Matrox g200/g400"
 	depends on DRM && PCI
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 45b3c03..594e06c 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -118,10 +118,10 @@ module_param_named(i915_enable_ppgtt, i915_enable_ppgtt, int, 0600);
 MODULE_PARM_DESC(i915_enable_ppgtt,
 		"Enable PPGTT (default: true)");
 
-unsigned int i915_preliminary_hw_support __read_mostly = 0;
+unsigned int i915_preliminary_hw_support __read_mostly = IS_ENABLED(CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT);
 module_param_named(preliminary_hw_support, i915_preliminary_hw_support, int, 0600);
 MODULE_PARM_DESC(preliminary_hw_support,
-		"Enable preliminary hardware support. (default: false)");
+		"Enable preliminary hardware support.");
 
 int i915_disable_power_well __read_mostly = 1;
 module_param_named(disable_power_well, i915_disable_power_well, int, 0600);
-- 
1.8.4.rc2

