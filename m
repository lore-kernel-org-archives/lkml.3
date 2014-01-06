Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbaAFX75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:59:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaAFWjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 073/144] drm/radeon: fix asic gfx values for scrapper asics
Date: Mon,  6 Jan 2014 14:37:14 -0800
Message-Id: <20140106223747.440172154@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e2f6c88fb903e123edfd1106b0b8310d5117f774 upstream.

Fixes gfx corruption on certain TN/RL parts.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=60389

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -900,6 +900,10 @@ static void cayman_gpu_init(struct radeo
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
@@ -910,6 +914,10 @@ static void cayman_gpu_init(struct radeo
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
@@ -920,9 +928,17 @@ static void cayman_gpu_init(struct radeo
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
@@ -930,10 +946,6 @@ static void cayman_gpu_init(struct radeo
 		rdev->config.cayman.max_gs_threads = 32;
 		rdev->config.cayman.max_stack_entries = 512;
 		rdev->config.cayman.sx_num_of_sets = 8;
-		rdev->config.cayman.sx_max_export_size = 256;
-		rdev->config.cayman.sx_max_export_pos_size = 64;
-		rdev->config.cayman.sx_max_export_smx_size = 192;
-		rdev->config.cayman.max_hw_contexts = 8;
 		rdev->config.cayman.sq_num_cf_insts = 2;
 
 		rdev->config.cayman.sc_prim_fifo_size = 0x40;


