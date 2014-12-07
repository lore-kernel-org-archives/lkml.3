Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaLGNtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:49:07 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45697 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaLGNtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:49:03 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: i915: intel_sideband.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 14:51:41 +0100
Message-Id: <1417960301-11366-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
vlv_flisdsi_read() vlv_gps_core_write() vlv_gps_core_read()
vlv_ccu_write() vlv_ccu_read() vlv_gpio_nc_read()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/i915/i915_drv.h       |    6 -----
 drivers/gpu/drm/i915/intel_sideband.c |   44 ---------------------------------
 2 files changed, 50 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 16a6f6d..d248957 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -2849,23 +2849,17 @@ int sandybridge_pcode_write(struct drm_i915_private *dev_priv, u8 mbox, u32 val)
 u32 vlv_punit_read(struct drm_i915_private *dev_priv, u8 addr);
 void vlv_punit_write(struct drm_i915_private *dev_priv, u8 addr, u32 val);
 u32 vlv_nc_read(struct drm_i915_private *dev_priv, u8 addr);
-u32 vlv_gpio_nc_read(struct drm_i915_private *dev_priv, u32 reg);
 void vlv_gpio_nc_write(struct drm_i915_private *dev_priv, u32 reg, u32 val);
 u32 vlv_cck_read(struct drm_i915_private *dev_priv, u32 reg);
 void vlv_cck_write(struct drm_i915_private *dev_priv, u32 reg, u32 val);
-u32 vlv_ccu_read(struct drm_i915_private *dev_priv, u32 reg);
-void vlv_ccu_write(struct drm_i915_private *dev_priv, u32 reg, u32 val);
 u32 vlv_bunit_read(struct drm_i915_private *dev_priv, u32 reg);
 void vlv_bunit_write(struct drm_i915_private *dev_priv, u32 reg, u32 val);
-u32 vlv_gps_core_read(struct drm_i915_private *dev_priv, u32 reg);
-void vlv_gps_core_write(struct drm_i915_private *dev_priv, u32 reg, u32 val);
 u32 vlv_dpio_read(struct drm_i915_private *dev_priv, enum pipe pipe, int reg);
 void vlv_dpio_write(struct drm_i915_private *dev_priv, enum pipe pipe, int reg, u32 val);
 u32 intel_sbi_read(struct drm_i915_private *dev_priv, u16 reg,
 		   enum intel_sbi_destination destination);
 void intel_sbi_write(struct drm_i915_private *dev_priv, u16 reg, u32 value,
 		     enum intel_sbi_destination destination);
-u32 vlv_flisdsi_read(struct drm_i915_private *dev_priv, u32 reg);
 void vlv_flisdsi_write(struct drm_i915_private *dev_priv, u32 reg, u32 val);
 
 int vlv_gpu_freq(struct drm_i915_private *dev_priv, int val);
diff --git a/drivers/gpu/drm/i915/intel_sideband.c b/drivers/gpu/drm/i915/intel_sideband.c
index 01d841e..5939171 100644
--- a/drivers/gpu/drm/i915/intel_sideband.c
+++ b/drivers/gpu/drm/i915/intel_sideband.c
@@ -129,14 +129,6 @@ u32 vlv_nc_read(struct drm_i915_private *dev_priv, u8 addr)
 	return val;
 }
 
-u32 vlv_gpio_nc_read(struct drm_i915_private *dev_priv, u32 reg)
-{
-	u32 val = 0;
-	vlv_sideband_rw(dev_priv, PCI_DEVFN(2, 0), IOSF_PORT_GPIO_NC,
-			SB_CRRDDA_NP, reg, &val);
-	return val;
-}
-
 void vlv_gpio_nc_write(struct drm_i915_private *dev_priv, u32 reg, u32 val)
 {
 	vlv_sideband_rw(dev_priv, PCI_DEVFN(2, 0), IOSF_PORT_GPIO_NC,
@@ -157,34 +149,6 @@ void vlv_cck_write(struct drm_i915_private *dev_priv, u32 reg, u32 val)
 			SB_CRWRDA_NP, reg, &val);
 }
 
-u32 vlv_ccu_read(struct drm_i915_private *dev_priv, u32 reg)
-{
-	u32 val = 0;
-	vlv_sideband_rw(dev_priv, PCI_DEVFN(2, 0), IOSF_PORT_CCU,
-			SB_CRRDDA_NP, reg, &val);
-	return val;
-}
-
-void vlv_ccu_write(struct drm_i915_private *dev_priv, u32 reg, u32 val)
-{
-	vlv_sideband_rw(dev_priv, PCI_DEVFN(2, 0), IOSF_PORT_CCU,
-			SB_CRWRDA_NP, reg, &val);
-}
-
-u32 vlv_gps_core_read(struct drm_i915_private *dev_priv, u32 reg)
-{
-	u32 val = 0;
-	vlv_sideband_rw(dev_priv, PCI_DEVFN(2, 0), IOSF_PORT_GPS_CORE,
-			SB_CRRDDA_NP, reg, &val);
-	return val;
-}
-
-void vlv_gps_core_write(struct drm_i915_private *dev_priv, u32 reg, u32 val)
-{
-	vlv_sideband_rw(dev_priv, PCI_DEVFN(2, 0), IOSF_PORT_GPS_CORE,
-			SB_CRWRDA_NP, reg, &val);
-}
-
 u32 vlv_dpio_read(struct drm_i915_private *dev_priv, enum pipe pipe, int reg)
 {
 	u32 val = 0;
@@ -267,14 +231,6 @@ void intel_sbi_write(struct drm_i915_private *dev_priv, u16 reg, u32 value,
 	}
 }
 
-u32 vlv_flisdsi_read(struct drm_i915_private *dev_priv, u32 reg)
-{
-	u32 val = 0;
-	vlv_sideband_rw(dev_priv, DPIO_DEVFN, IOSF_PORT_FLISDSI, SB_CRRDDA_NP,
-			reg, &val);
-	return val;
-}
-
 void vlv_flisdsi_write(struct drm_i915_private *dev_priv, u32 reg, u32 val)
 {
 	vlv_sideband_rw(dev_priv, DPIO_DEVFN, IOSF_PORT_FLISDSI, SB_CRWRDA_NP,
-- 
1.7.10.4

