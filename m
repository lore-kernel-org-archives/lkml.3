Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaETQ3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:29:22 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:10703 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbaETQ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:29:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEWAHGBe1NbsnsG/2dsb2JhbABZgwarBQQBAQEBAQEFAYM6lm4CAoEcF3SCUxM/GIECJBOIRQHUIYVViHmERwEDjzyKKwGLEogOgzo7
Date: Tue, 20 May 2014 18:29:18 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 1/1]  drivers/gpu/drm/radeon/ci_dpm.c: replace shift loop by
 ilog2
Message-Id: <20140520182918.0259b9804a1b01693cb2b287@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 10dae41..e4abf9e 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -3725,10 +3725,8 @@ int ci_dpm_force_performance_level(struct radeon_device *rdev,
 	if (level == RADEON_DPM_FORCED_LEVEL_HIGH) {
 		if ((!pi->sclk_dpm_key_disabled) &&
 		    pi->dpm_level_enable_mask.sclk_dpm_enable_mask) {
-			levels = 0;
 			tmp = pi->dpm_level_enable_mask.sclk_dpm_enable_mask;
-			while (tmp >>= 1)
-				levels++;
+			levels = ilog2(tmp);
 			if (levels) {
 				ret = ci_dpm_force_state_sclk(rdev, levels);
 				if (ret)
@@ -3744,10 +3742,8 @@ int ci_dpm_force_performance_level(struct radeon_device *rdev,
 		}
 		if ((!pi->mclk_dpm_key_disabled) &&
 		    pi->dpm_level_enable_mask.mclk_dpm_enable_mask) {
-			levels = 0;
 			tmp = pi->dpm_level_enable_mask.mclk_dpm_enable_mask;
-			while (tmp >>= 1)
-				levels++;
+			levels = ilog2(tmp);
 			if (levels) {
 				ret = ci_dpm_force_state_mclk(rdev, levels);
 				if (ret)
@@ -3763,10 +3759,8 @@ int ci_dpm_force_performance_level(struct radeon_device *rdev,
 		}
 		if ((!pi->pcie_dpm_key_disabled) &&
 		    pi->dpm_level_enable_mask.pcie_dpm_enable_mask) {
-			levels = 0;
 			tmp = pi->dpm_level_enable_mask.pcie_dpm_enable_mask;
-			while (tmp >>= 1)
-				levels++;
+			levels = ilog2(tmp);
 			if (levels) {
 				ret = ci_dpm_force_state_pcie(rdev, level);
 				if (ret)
-- 
1.8.4.5

