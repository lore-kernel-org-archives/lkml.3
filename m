Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaKHSi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:38:58 -0500
Received: from mail-bn1bon0112.outbound.protection.outlook.com ([157.56.111.112]:2198
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753914AbaKHSi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:38:57 -0500
X-WSS-ID: 0NEQH4S-07-RD5-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v5 02/24] drm/radeon/cik: Don't touch int of pipes 1-7
Date: Sat, 8 Nov 2014 20:37:23 +0200
Message-ID: <1415471865-1893-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(64706001)(95666004)(50986999)(87286001)(93916002)(97736003)(106466001)(77096003)(84676001)(99396003)(62966003)(77156002)(33646002)(89996001)(86362001)(105586002)(19580405001)(53416004)(19580395003)(68736004)(36756003)(44976005)(92566001)(120916001)(87936001)(229853001)(46102003)(101416001)(47776003)(104166001)(50466002)(20776003)(88136002)(92726001)(48376002)(102836001)(31966008)(76176999)(50226001)(107046002)(4396001)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amdkfd should set interrupts for pipes 1-7.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c | 71 +-------------------------------------------
 1 file changed, 1 insertion(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index a7d73f9..b798aab 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7281,8 +7281,7 @@ static int cik_irq_init(struct radeon_device *rdev)
 int cik_irq_set(struct radeon_device *rdev)
 {
 	u32 cp_int_cntl;
-	u32 cp_m1p0, cp_m1p1, cp_m1p2, cp_m1p3;
-	u32 cp_m2p0, cp_m2p1, cp_m2p2, cp_m2p3;
+	u32 cp_m1p0;
 	u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
 	u32 hpd1, hpd2, hpd3, hpd4, hpd5, hpd6;
 	u32 grbm_int_cntl = 0;
@@ -7316,13 +7315,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7344,33 +7336,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7387,33 +7352,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7502,13 +7440,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
2.1.0

