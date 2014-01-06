Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaAFQI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:08:59 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61440 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaAFQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:08:58 -0500
Date: Mon, 6 Jan 2014 21:38:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 54/85] drivers: gpu: Move prototype declarations to header
 file rv770_dpm.h
Message-ID: <7c8705c9ab56cedaef8c30d3faef20d8141c57eb.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of functions rv770_get_ps(), rv770_get_pi()
and evergreen_get_pi() to header file drm/radeon/rv770_dpm.h because
they are used by more than one file.

This eliminates the following warnings in drm/radeon/rv770_dpm.c:
drivers/gpu/drm/radeon/rv770_dpm.c:47:18: warning: no previous prototype for ‘rv770_get_ps’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:54:26: warning: no previous prototype for ‘rv770_get_pi’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/rv770_dpm.c:61:30: warning: no previous prototype for ‘evergreen_get_pi’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/btc_dpm.c     |    4 ----
 drivers/gpu/drm/radeon/cypress_dpm.c |    4 ----
 drivers/gpu/drm/radeon/ni_dpm.c      |    3 ---
 drivers/gpu/drm/radeon/rv730_dpm.c   |    3 ---
 drivers/gpu/drm/radeon/rv740_dpm.c   |    2 --
 drivers/gpu/drm/radeon/rv770_dpm.h   |    4 ++++
 drivers/gpu/drm/radeon/si_dpm.c      |    2 --
 7 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/radeon/btc_dpm.c b/drivers/gpu/drm/radeon/btc_dpm.c
index 9b6950d..4261c3f 100644
--- a/drivers/gpu/drm/radeon/btc_dpm.c
+++ b/drivers/gpu/drm/radeon/btc_dpm.c
@@ -45,10 +45,6 @@
 #ifndef BTC_MGCG_SEQUENCE
 #define BTC_MGCG_SEQUENCE  300
 
-struct rv7xx_ps *rv770_get_ps(struct radeon_ps *rps);
-struct rv7xx_power_info *rv770_get_pi(struct radeon_device *rdev);
-struct evergreen_power_info *evergreen_get_pi(struct radeon_device *rdev);
-
 
 //********* BARTS **************//
 static const u32 barts_cgcg_cgls_default[] =
diff --git a/drivers/gpu/drm/radeon/cypress_dpm.c b/drivers/gpu/drm/radeon/cypress_dpm.c
index 920e1e4..75dc1d8 100644
--- a/drivers/gpu/drm/radeon/cypress_dpm.c
+++ b/drivers/gpu/drm/radeon/cypress_dpm.c
@@ -41,10 +41,6 @@
 #define MC_CG_SEQ_YCLK_SUSPEND      0x04
 #define MC_CG_SEQ_YCLK_RESUME       0x0a
 
-struct rv7xx_ps *rv770_get_ps(struct radeon_ps *rps);
-struct rv7xx_power_info *rv770_get_pi(struct radeon_device *rdev);
-struct evergreen_power_info *evergreen_get_pi(struct radeon_device *rdev);
-
 static void cypress_enable_bif_dynamic_pcie_gen2(struct radeon_device *rdev,
 						 bool enable)
 {
diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 49c4d48..33a1e21 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -717,9 +717,6 @@ static const u32 cayman_sysls_enable[] =
 };
 #define CAYMAN_SYSLS_ENABLE_LENGTH sizeof(cayman_sysls_enable) / (3 * sizeof(u32))
 
-struct rv7xx_power_info *rv770_get_pi(struct radeon_device *rdev);
-struct evergreen_power_info *evergreen_get_pi(struct radeon_device *rdev);
-
 struct ni_power_info *ni_get_pi(struct radeon_device *rdev)
 {
         struct ni_power_info *pi = rdev->pm.dpm.priv;
diff --git a/drivers/gpu/drm/radeon/rv730_dpm.c b/drivers/gpu/drm/radeon/rv730_dpm.c
index 3f5e1cf..f07b87d 100644
--- a/drivers/gpu/drm/radeon/rv730_dpm.c
+++ b/drivers/gpu/drm/radeon/rv730_dpm.c
@@ -34,9 +34,6 @@
 #define MC_CG_ARB_FREQ_F2           0x0c
 #define MC_CG_ARB_FREQ_F3           0x0d
 
-struct rv7xx_ps *rv770_get_ps(struct radeon_ps *rps);
-struct rv7xx_power_info *rv770_get_pi(struct radeon_device *rdev);
-
 int rv730_populate_sclk_value(struct radeon_device *rdev,
 			      u32 engine_clock,
 			      RV770_SMC_SCLK_VALUE *sclk)
diff --git a/drivers/gpu/drm/radeon/rv740_dpm.c b/drivers/gpu/drm/radeon/rv740_dpm.c
index c4c8da5..ca714f8 100644
--- a/drivers/gpu/drm/radeon/rv740_dpm.c
+++ b/drivers/gpu/drm/radeon/rv740_dpm.c
@@ -29,8 +29,6 @@
 #include "rv770_dpm.h"
 #include "atom.h"
 
-struct rv7xx_power_info *rv770_get_pi(struct radeon_device *rdev);
-
 u32 rv740_get_decoded_reference_divider(u32 encoded_ref)
 {
 	u32 ref = 0;
diff --git a/drivers/gpu/drm/radeon/rv770_dpm.h b/drivers/gpu/drm/radeon/rv770_dpm.h
index 9244eff..2d74927 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.h
+++ b/drivers/gpu/drm/radeon/rv770_dpm.h
@@ -213,6 +213,10 @@ u32 rv740_get_dll_speed(bool is_gddr5, u32 memory_clock);
 u32 rv740_get_decoded_reference_divider(u32 encoded_ref);
 
 /* rv770 */
+struct rv7xx_ps *rv770_get_ps(struct radeon_ps *rps);
+struct rv7xx_power_info *rv770_get_pi(struct radeon_device *rdev);
+struct evergreen_power_info *evergreen_get_pi(struct radeon_device *rdev);
+
 u32 rv770_map_clkf_to_ibias(struct radeon_device *rdev, u32 clkf);
 int rv770_populate_vddc_value(struct radeon_device *rdev, u16 vddc,
 			      RV770_SMC_VOLTAGE_VALUE *voltage);
diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index a3a5866..8732005 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -1734,8 +1734,6 @@ static const struct si_powertune_data powertune_data_hainan =
 	true
 };
 
-struct rv7xx_power_info *rv770_get_pi(struct radeon_device *rdev);
-struct evergreen_power_info *evergreen_get_pi(struct radeon_device *rdev);
 struct ni_power_info *ni_get_pi(struct radeon_device *rdev);
 struct ni_ps *ni_get_ps(struct radeon_ps *rps);
 
-- 
1.7.9.5

