Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaHEPbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:31:55 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:9226
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885AbaHEPbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:31:53 -0400
X-WSS-ID: 0N9UB4Z-07-3DJ-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 02/23] drm/radeon/cik: Don't touch int of pipes 1-7
Date: Tue, 5 Aug 2014 18:30:30 +0300
Message-ID: <1407252651-3539-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(84676001)(50466002)(87936001)(104166001)(62966002)(83072002)(86362001)(101416001)(92726001)(88136002)(92566001)(83322001)(19580405001)(95666004)(87286001)(79102001)(19580395003)(107046002)(77096002)(89996001)(4396001)(77156001)(85852003)(48376002)(50226001)(81342001)(31966008)(97736001)(21056001)(105586002)(36756003)(33646002)(99396002)(106466001)(68736004)(229853001)(77982001)(64706001)(46102001)(76176999)(74502001)(44976005)(20776003)(81542001)(74662001)(47776003)(76482001)(102836001)(80022001)(85306004)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB040;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amdkfd should set interrupts for pipes 1-7.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c | 71 +-------------------------------------------
 1 file changed, 1 insertion(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 9571be8..d54d3d7 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7265,8 +7265,7 @@ static int cik_irq_init(struct radeon_device *rdev)
 int cik_irq_set(struct radeon_device *rdev)
 {
 	u32 cp_int_cntl;
-	u32 cp_m1p0, cp_m1p1, cp_m1p2, cp_m1p3;
-	u32 cp_m2p0, cp_m2p1, cp_m2p2, cp_m2p3;
+	u32 cp_m1p0;
 	u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
 	u32 hpd1, hpd2, hpd3, hpd4, hpd5, hpd6;
 	u32 grbm_int_cntl = 0;
@@ -7300,13 +7299,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7328,33 +7320,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7371,33 +7336,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7486,13 +7424,6 @@ int cik_irq_set(struct radeon_device *rdev)
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

