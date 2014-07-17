Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaGQNbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:31:34 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:48665
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932139AbaGQNbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:31:31 -0400
X-WSS-ID: 0N8UYWD-08-6U8-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 03/25] drm/radeon/cik: Don't touch int of pipes 1-7
Date: Thu, 17 Jul 2014 16:29:10 +0300
Message-ID: <1405603773-32688-4-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(31966008)(84676001)(77982001)(74502001)(76482001)(20776003)(93916002)(50226001)(47776003)(44976005)(83322001)(19580405001)(86362001)(19580395003)(50986999)(46102001)(102836001)(33646002)(80022001)(107046002)(74662001)(21056001)(104166001)(4396001)(88136002)(77156001)(81542001)(92726001)(50466002)(81342001)(106466001)(92566001)(36756003)(105586002)(101416001)(85852003)(48376002)(83072002)(89996001)(85306003)(68736004)(99396002)(76176999)(95666004)(87286001)(229853001)(64706001)(87936001)(62966002)(79102001)(77096002)(97736001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB039;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
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
index 0b53633..1d7dd3b 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7270,8 +7270,7 @@ static int cik_irq_init(struct radeon_device *rdev)
 int cik_irq_set(struct radeon_device *rdev)
 {
 	u32 cp_int_cntl;
-	u32 cp_m1p0, cp_m1p1, cp_m1p2, cp_m1p3;
-	u32 cp_m2p0, cp_m2p1, cp_m2p2, cp_m2p3;
+	u32 cp_m1p0;
 	u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
 	u32 hpd1, hpd2, hpd3, hpd4, hpd5, hpd6;
 	u32 grbm_int_cntl = 0;
@@ -7305,13 +7304,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7333,33 +7325,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7376,33 +7341,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7485,13 +7423,6 @@ int cik_irq_set(struct radeon_device *rdev)
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

