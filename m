Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab3APQEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:04:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318Ab3APQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 105/222] drm/radeon: fix amd afusion gpu setup aka sumo v2
Date: Wed, 16 Jan 2013 13:55:05 -0200
Message-Id: <1358351822-7675-106-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit bd25f0783dc3fb72e1e2779c2b99b2d34b67fa8a upstream.

Set the proper number of tile pipe that should be a multiple of
pipe depending on the number of se engine.

Fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56405
https://bugs.freedesktop.org/show_bug.cgi?id=56720

v2: Don't change sumo2

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c  |    8 ++++----
 drivers/gpu/drm/radeon/evergreend.h |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index fb868675..2aa7fdb 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1639,7 +1639,7 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 	case CHIP_SUMO:
 		rdev->config.evergreen.num_ses = 1;
 		rdev->config.evergreen.max_pipes = 4;
-		rdev->config.evergreen.max_tile_pipes = 2;
+		rdev->config.evergreen.max_tile_pipes = 4;
 		if (rdev->pdev->device == 0x9648)
 			rdev->config.evergreen.max_simds = 3;
 		else if ((rdev->pdev->device == 0x9647) ||
@@ -1662,7 +1662,7 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;
 		rdev->config.evergreen.sc_hiz_tile_fifo_size = 0x30;
 		rdev->config.evergreen.sc_earlyz_tile_fifo_size = 0x130;
-		gb_addr_config = REDWOOD_GB_ADDR_CONFIG_GOLDEN;
+		gb_addr_config = SUMO_GB_ADDR_CONFIG_GOLDEN;
 		break;
 	case CHIP_SUMO2:
 		rdev->config.evergreen.num_ses = 1;
@@ -1684,7 +1684,7 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;
 		rdev->config.evergreen.sc_hiz_tile_fifo_size = 0x30;
 		rdev->config.evergreen.sc_earlyz_tile_fifo_size = 0x130;
-		gb_addr_config = REDWOOD_GB_ADDR_CONFIG_GOLDEN;
+		gb_addr_config = SUMO2_GB_ADDR_CONFIG_GOLDEN;
 		break;
 	case CHIP_BARTS:
 		rdev->config.evergreen.num_ses = 2;
@@ -1732,7 +1732,7 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 		break;
 	case CHIP_CAICOS:
 		rdev->config.evergreen.num_ses = 1;
-		rdev->config.evergreen.max_pipes = 4;
+		rdev->config.evergreen.max_pipes = 2;
 		rdev->config.evergreen.max_tile_pipes = 2;
 		rdev->config.evergreen.max_simds = 2;
 		rdev->config.evergreen.max_backends = 1 * rdev->config.evergreen.num_ses;
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index d2f0528..735e515 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -45,6 +45,8 @@
 #define TURKS_GB_ADDR_CONFIG_GOLDEN          0x02010002
 #define CEDAR_GB_ADDR_CONFIG_GOLDEN          0x02010001
 #define CAICOS_GB_ADDR_CONFIG_GOLDEN         0x02010001
+#define SUMO_GB_ADDR_CONFIG_GOLDEN           0x02010002
+#define SUMO2_GB_ADDR_CONFIG_GOLDEN          0x02010002
 
 /* Registers */
 
-- 
1.7.9.5

