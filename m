Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaGJVx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:53:58 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:51330 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaGJVwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:17 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 23/83] drm/radeon/cik: Don't touch int of pipes 1-7
Date: Fri, 11 Jul 2014 00:50:23 +0300
Message-Id: <1405029027-6085-22-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HSA radeon driver (kfd) should set interrupts for pipes 1-7.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c | 71 +-------------------------------------------
 1 file changed, 1 insertion(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index b1c50f4..803d0cb 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7272,8 +7272,7 @@ static int cik_irq_init(struct radeon_device *rdev)
 int cik_irq_set(struct radeon_device *rdev)
 {
 	u32 cp_int_cntl;
-	u32 cp_m1p0, cp_m1p1, cp_m1p2, cp_m1p3;
-	u32 cp_m2p0, cp_m2p1, cp_m2p2, cp_m2p3;
+	u32 cp_m1p0;
 	u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
 	u32 hpd1, hpd2, hpd3, hpd4, hpd5, hpd6;
 	u32 grbm_int_cntl = 0;
@@ -7307,13 +7306,6 @@ int cik_irq_set(struct radeon_device *rdev)
 	dma_cntl1 = RREG32(SDMA0_CNTL + SDMA1_REGISTER_OFFSET) & ~TRAP_ENABLE;
 
 	cp_m1p0 = RREG32(CP_ME1_PIPE0_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
-	cp_m1p1 = RREG32(CP_ME1_PIPE1_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
-	cp_m1p2 = RREG32(CP_ME1_PIPE2_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
-	cp_m1p3 = RREG32(CP_ME1_PIPE3_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
-	cp_m2p0 = RREG32(CP_ME2_PIPE0_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
-	cp_m2p1 = RREG32(CP_ME2_PIPE1_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
-	cp_m2p2 = RREG32(CP_ME2_PIPE2_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
-	cp_m2p3 = RREG32(CP_ME2_PIPE3_INT_CNTL) & ~TIME_STAMP_INT_ENABLE;
 
 	if (rdev->flags & RADEON_IS_IGP)
 		thermal_int = RREG32_SMC(CG_THERMAL_INT_CTRL) &
@@ -7335,33 +7327,6 @@ int cik_irq_set(struct radeon_device *rdev)
 			case 0:
 				cp_m1p0 |= TIME_STAMP_INT_ENABLE;
 				break;
-			case 1:
-				cp_m1p1 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 2:
-				cp_m1p2 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 3:
-				cp_m1p2 |= TIME_STAMP_INT_ENABLE;
-				break;
-			default:
-				DRM_DEBUG("si_irq_set: sw int cp1 invalid pipe %d\n", ring->pipe);
-				break;
-			}
-		} else if (ring->me == 2) {
-			switch (ring->pipe) {
-			case 0:
-				cp_m2p0 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 1:
-				cp_m2p1 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 2:
-				cp_m2p2 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 3:
-				cp_m2p2 |= TIME_STAMP_INT_ENABLE;
-				break;
 			default:
 				DRM_DEBUG("si_irq_set: sw int cp1 invalid pipe %d\n", ring->pipe);
 				break;
@@ -7378,33 +7343,6 @@ int cik_irq_set(struct radeon_device *rdev)
 			case 0:
 				cp_m1p0 |= TIME_STAMP_INT_ENABLE;
 				break;
-			case 1:
-				cp_m1p1 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 2:
-				cp_m1p2 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 3:
-				cp_m1p2 |= TIME_STAMP_INT_ENABLE;
-				break;
-			default:
-				DRM_DEBUG("si_irq_set: sw int cp2 invalid pipe %d\n", ring->pipe);
-				break;
-			}
-		} else if (ring->me == 2) {
-			switch (ring->pipe) {
-			case 0:
-				cp_m2p0 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 1:
-				cp_m2p1 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 2:
-				cp_m2p2 |= TIME_STAMP_INT_ENABLE;
-				break;
-			case 3:
-				cp_m2p2 |= TIME_STAMP_INT_ENABLE;
-				break;
 			default:
 				DRM_DEBUG("si_irq_set: sw int cp2 invalid pipe %d\n", ring->pipe);
 				break;
@@ -7487,13 +7425,6 @@ int cik_irq_set(struct radeon_device *rdev)
 	WREG32(SDMA0_CNTL + SDMA1_REGISTER_OFFSET, dma_cntl1);
 
 	WREG32(CP_ME1_PIPE0_INT_CNTL, cp_m1p0);
-	WREG32(CP_ME1_PIPE1_INT_CNTL, cp_m1p1);
-	WREG32(CP_ME1_PIPE2_INT_CNTL, cp_m1p2);
-	WREG32(CP_ME1_PIPE3_INT_CNTL, cp_m1p3);
-	WREG32(CP_ME2_PIPE0_INT_CNTL, cp_m2p0);
-	WREG32(CP_ME2_PIPE1_INT_CNTL, cp_m2p1);
-	WREG32(CP_ME2_PIPE2_INT_CNTL, cp_m2p2);
-	WREG32(CP_ME2_PIPE3_INT_CNTL, cp_m2p3);
 
 	WREG32(GRBM_INT_CNTL, grbm_int_cntl);
 
-- 
1.9.1

