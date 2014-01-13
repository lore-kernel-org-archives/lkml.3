Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaAMQDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53197 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaAMQCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 082/208] drm/radeon: fix asic gfx values for scrapper asics
Date: Mon, 13 Jan 2014 15:58:43 +0000
Message-Id: <1389628849-1614-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e2f6c88fb903e123edfd1106b0b8310d5117f774 upstream.

Fixes gfx corruption on certain TN/RL parts.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=60389

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 263d14b..b2a76f5 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -896,6 +896,10 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		    (rdev->pdev->device == 0x999C)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
+			rdev->config.cayman.max_hw_contexts = 8;
+			rdev->config.cayman.sx_max_export_size = 256;
+			rdev->config.cayman.sx_max_export_pos_size = 64;
+			rdev->config.cayman.sx_max_export_smx_size = 192;
 		} else if ((rdev->pdev->device == 0x9903) ||
 			   (rdev->pdev->device == 0x9904) ||
 			   (rdev->pdev->device == 0x990A) ||
@@ -906,6 +910,10 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x999D)) {
 			rdev->config.cayman.max_simds_per_se = 4;
 			rdev->config.cayman.max_backends_per_se = 2;
+			rdev->config.cayman.max_hw_contexts = 8;
+			rdev->config.cayman.sx_max_export_size = 256;
+			rdev->config.cayman.sx_max_export_pos_size = 64;
+			rdev->config.cayman.sx_max_export_smx_size = 192;
 		} else if ((rdev->pdev->device == 0x9919) ||
 			   (rdev->pdev->device == 0x9990) ||
 			   (rdev->pdev->device == 0x9991) ||
@@ -916,9 +924,17 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x99A0)) {
 			rdev->config.cayman.max_simds_per_se = 3;
 			rdev->config.cayman.max_backends_per_se = 1;
+			rdev->config.cayman.max_hw_contexts = 4;
+			rdev->config.cayman.sx_max_export_size = 128;
+			rdev->config.cayman.sx_max_export_pos_size = 32;
+			rdev->config.cayman.sx_max_export_smx_size = 96;
 		} else {
 			rdev->config.cayman.max_simds_per_se = 2;
 			rdev->config.cayman.max_backends_per_se = 1;
+			rdev->config.cayman.max_hw_contexts = 4;
+			rdev->config.cayman.sx_max_export_size = 128;
+			rdev->config.cayman.sx_max_export_pos_size = 32;
+			rdev->config.cayman.sx_max_export_smx_size = 96;
 		}
 		rdev->config.cayman.max_texture_channel_caches = 2;
 		rdev->config.cayman.max_gprs = 256;
@@ -926,10 +942,6 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		rdev->config.cayman.max_gs_threads = 32;
 		rdev->config.cayman.max_stack_entries = 512;
 		rdev->config.cayman.sx_num_of_sets = 8;
-		rdev->config.cayman.sx_max_export_size = 256;
-		rdev->config.cayman.sx_max_export_pos_size = 64;
-		rdev->config.cayman.sx_max_export_smx_size = 192;
-		rdev->config.cayman.max_hw_contexts = 8;
 		rdev->config.cayman.sq_num_cf_insts = 2;
 
 		rdev->config.cayman.sc_prim_fifo_size = 0x40;
-- 
1.8.3.2

