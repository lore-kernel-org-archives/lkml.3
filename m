Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3I2Til (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:38:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab3I2T3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 51/71] drm/radeon/r6xx: add a stubbed out set_uvd_clocks callback
Date: Sun, 29 Sep 2013 12:28:03 -0700
Message-Id: <20130929192646.959632126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1b9ba70a49ba92e910d8e5df702edf8c1858cecf upstream.

Certain r6xx boards use the same power state for both UVD
and other things.  Since we don't support UVD on r6xx boards
at the moment, there was no callback installed for setting
the UVD clocks, however, on systems that use the same power
state, this leads to a NULL pointer dereference.  Fill
in a stubbed out implementation for now to avoid the crash.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=66963

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600.c        |    5 +++++
 drivers/gpu/drm/radeon/radeon_asic.c |    2 ++
 drivers/gpu/drm/radeon/radeon_asic.h |    1 +
 3 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -119,6 +119,11 @@ u32 r600_get_xclk(struct radeon_device *
 	return rdev->clock.spll.reference_freq;
 }
 
+int r600_set_uvd_clocks(struct radeon_device *rdev, u32 vclk, u32 dclk)
+{
+	return 0;
+}
+
 /* get temperature in millidegrees */
 int rv6xx_get_temp(struct radeon_device *rdev)
 {
--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -1146,6 +1146,7 @@ static struct radeon_asic rv6xx_asic = {
 		.set_pcie_lanes = &r600_set_pcie_lanes,
 		.set_clock_gating = NULL,
 		.get_temperature = &rv6xx_get_temp,
+		.set_uvd_clocks = &r600_set_uvd_clocks,
 	},
 	.dpm = {
 		.init = &rv6xx_dpm_init,
@@ -1257,6 +1258,7 @@ static struct radeon_asic rs780_asic = {
 		.set_pcie_lanes = NULL,
 		.set_clock_gating = NULL,
 		.get_temperature = &rv6xx_get_temp,
+		.set_uvd_clocks = &r600_set_uvd_clocks,
 	},
 	.dpm = {
 		.init = &rs780_dpm_init,
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -405,6 +405,7 @@ int r600_mc_wait_for_idle(struct radeon_
 u32 r600_get_xclk(struct radeon_device *rdev);
 uint64_t r600_get_gpu_clock_counter(struct radeon_device *rdev);
 int rv6xx_get_temp(struct radeon_device *rdev);
+int r600_set_uvd_clocks(struct radeon_device *rdev, u32 vclk, u32 dclk);
 int r600_dpm_pre_set_power_state(struct radeon_device *rdev);
 void r600_dpm_post_set_power_state(struct radeon_device *rdev);
 /* rv6xx dpm */


