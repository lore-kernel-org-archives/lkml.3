Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab3I2TcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:32:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab3I2T37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 37/71] drm/radeon: fill in gpu_init for berlin GPU cores
Date: Sun, 29 Sep 2013 12:27:49 -0700
Message-Id: <20130929192646.032697011@linuxfoundation.org>
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

commit b2e4c70a9747ecb618d563b004ba746869dde5aa upstream.

This fills in the GPU specific details for berlin
GPU cores so that the driver will work with them.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1880,7 +1880,46 @@ static void cik_gpu_init(struct radeon_d
 		gb_addr_config = BONAIRE_GB_ADDR_CONFIG_GOLDEN;
 		break;
 	case CHIP_KAVERI:
-		/* TODO */
+		rdev->config.cik.max_shader_engines = 1;
+		rdev->config.cik.max_tile_pipes = 4;
+		if ((rdev->pdev->device == 0x1304) ||
+		    (rdev->pdev->device == 0x1305) ||
+		    (rdev->pdev->device == 0x130C) ||
+		    (rdev->pdev->device == 0x130F) ||
+		    (rdev->pdev->device == 0x1310) ||
+		    (rdev->pdev->device == 0x1311) ||
+		    (rdev->pdev->device == 0x131C)) {
+			rdev->config.cik.max_cu_per_sh = 8;
+			rdev->config.cik.max_backends_per_se = 2;
+		} else if ((rdev->pdev->device == 0x1309) ||
+			   (rdev->pdev->device == 0x130A) ||
+			   (rdev->pdev->device == 0x130D) ||
+			   (rdev->pdev->device == 0x1313)) {
+			rdev->config.cik.max_cu_per_sh = 6;
+			rdev->config.cik.max_backends_per_se = 2;
+		} else if ((rdev->pdev->device == 0x1306) ||
+			   (rdev->pdev->device == 0x1307) ||
+			   (rdev->pdev->device == 0x130B) ||
+			   (rdev->pdev->device == 0x130E) ||
+			   (rdev->pdev->device == 0x1315) ||
+			   (rdev->pdev->device == 0x131B)) {
+			rdev->config.cik.max_cu_per_sh = 4;
+			rdev->config.cik.max_backends_per_se = 1;
+		} else {
+			rdev->config.cik.max_cu_per_sh = 3;
+			rdev->config.cik.max_backends_per_se = 1;
+		}
+		rdev->config.cik.max_sh_per_se = 1;
+		rdev->config.cik.max_texture_channel_caches = 4;
+		rdev->config.cik.max_gprs = 256;
+		rdev->config.cik.max_gs_threads = 16;
+		rdev->config.cik.max_hw_contexts = 8;
+
+		rdev->config.cik.sc_prim_fifo_size_frontend = 0x20;
+		rdev->config.cik.sc_prim_fifo_size_backend = 0x100;
+		rdev->config.cik.sc_hiz_tile_fifo_size = 0x30;
+		rdev->config.cik.sc_earlyz_tile_fifo_size = 0x130;
+		gb_addr_config = BONAIRE_GB_ADDR_CONFIG_GOLDEN;
 		break;
 	case CHIP_KABINI:
 	default:


