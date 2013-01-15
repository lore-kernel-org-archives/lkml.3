Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab3AOW3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:29:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:41797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045Ab3AOW3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 071/221] drm/radeon: fix amd afusion gpu setup aka sumo v2
Date: Tue, 15 Jan 2013 10:49:58 -0800
Message-Id: <20130115185003.189732855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c  |    8 ++++----
 drivers/gpu/drm/radeon/evergreend.h |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1821,7 +1821,7 @@ static void evergreen_gpu_init(struct ra
 	case CHIP_SUMO:
 		rdev->config.evergreen.num_ses = 1;
 		rdev->config.evergreen.max_pipes = 4;
-		rdev->config.evergreen.max_tile_pipes = 2;
+		rdev->config.evergreen.max_tile_pipes = 4;
 		if (rdev->pdev->device == 0x9648)
 			rdev->config.evergreen.max_simds = 3;
 		else if ((rdev->pdev->device == 0x9647) ||
@@ -1844,7 +1844,7 @@ static void evergreen_gpu_init(struct ra
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;
 		rdev->config.evergreen.sc_hiz_tile_fifo_size = 0x30;
 		rdev->config.evergreen.sc_earlyz_tile_fifo_size = 0x130;
-		gb_addr_config = REDWOOD_GB_ADDR_CONFIG_GOLDEN;
+		gb_addr_config = SUMO_GB_ADDR_CONFIG_GOLDEN;
 		break;
 	case CHIP_SUMO2:
 		rdev->config.evergreen.num_ses = 1;
@@ -1866,7 +1866,7 @@ static void evergreen_gpu_init(struct ra
 		rdev->config.evergreen.sc_prim_fifo_size = 0x40;
 		rdev->config.evergreen.sc_hiz_tile_fifo_size = 0x30;
 		rdev->config.evergreen.sc_earlyz_tile_fifo_size = 0x130;
-		gb_addr_config = REDWOOD_GB_ADDR_CONFIG_GOLDEN;
+		gb_addr_config = SUMO2_GB_ADDR_CONFIG_GOLDEN;
 		break;
 	case CHIP_BARTS:
 		rdev->config.evergreen.num_ses = 2;
@@ -1914,7 +1914,7 @@ static void evergreen_gpu_init(struct ra
 		break;
 	case CHIP_CAICOS:
 		rdev->config.evergreen.num_ses = 1;
-		rdev->config.evergreen.max_pipes = 4;
+		rdev->config.evergreen.max_pipes = 2;
 		rdev->config.evergreen.max_tile_pipes = 2;
 		rdev->config.evergreen.max_simds = 2;
 		rdev->config.evergreen.max_backends = 1 * rdev->config.evergreen.num_ses;
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -45,6 +45,8 @@
 #define TURKS_GB_ADDR_CONFIG_GOLDEN          0x02010002
 #define CEDAR_GB_ADDR_CONFIG_GOLDEN          0x02010001
 #define CAICOS_GB_ADDR_CONFIG_GOLDEN         0x02010001
+#define SUMO_GB_ADDR_CONFIG_GOLDEN           0x02010002
+#define SUMO2_GB_ADDR_CONFIG_GOLDEN          0x02010002
 
 /* Registers */
 


