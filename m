Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3ETKwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3ETKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 010/115] drm/radeon/dce6: add missing display reg for tiling setup
Date: Mon, 20 May 2013 11:50:10 +0100
Message-Id: <1369047116-9378-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7c1c7c18fc752b2a1d07597286467ef186312463 upstream.

A new tiling config register for the display blocks was
added on DCE6.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=62889
https://bugs.freedesktop.org/show_bug.cgi?id=57919

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni.c  | 2 ++
 drivers/gpu/drm/radeon/nid.h | 4 ++++
 drivers/gpu/drm/radeon/si.c  | 1 +
 drivers/gpu/drm/radeon/sid.h | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 0aa705e..09853ac 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -619,6 +619,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	if (ASIC_IS_DCE6(rdev))
+		WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	if ((rdev->config.cayman.max_backends_per_se == 1) &&
diff --git a/drivers/gpu/drm/radeon/nid.h b/drivers/gpu/drm/radeon/nid.h
index 5e76c2f5..dd334a2 100644
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -45,6 +45,10 @@
 #define ARUBA_GB_ADDR_CONFIG_GOLDEN        0x12010001
 
 #define DMIF_ADDR_CONFIG  				0xBD4
+
+/* DCE6 only */
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_GFX_CNTL				        0x0E44
 #define		RINGID(x)					(((x) & 0x3) << 0)
 #define		VMID(x)						(((x) & 0x7) << 0)
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 29e42de..bc044f5 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1659,6 +1659,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	si_tiling_mode_table_init(rdev);
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 06b17e6..916e13f 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -60,6 +60,8 @@
 
 #define DMIF_ADDR_CONFIG  				0xBD4
 
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_STATUS				        0xE50
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0xe80
-- 
1.8.1.2

