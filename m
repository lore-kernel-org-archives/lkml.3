Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaIXVCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:02:43 -0400
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:42954
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751742AbaIXVCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:02:33 -0400
X-WSS-ID: 0NCFB1J-07-T2B-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 02/23] drm/radeon/cik: Don't touch int of pipes 1-7
Date: Wed, 24 Sep 2014 23:45:16 +0300
Message-ID: <1411591537-31636-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(85852003)(48376002)(85306004)(50466002)(46102003)(77156001)(31966008)(50986999)(77096002)(81342003)(19580395003)(68736004)(87936001)(83322001)(120916001)(83072002)(84676001)(99396003)(74662003)(107046002)(44976005)(90102001)(92726001)(76482002)(47776003)(106466001)(74502003)(102836001)(229853001)(50226001)(20776003)(104166001)(64706001)(89996001)(105586002)(21056001)(92566001)(62966002)(101416001)(95666004)(19580405001)(80022003)(76176999)(88136002)(79102003)(87286001)(33646002)(81542003)(77982003)(10300001)(97736003)(4396001)(93916002)(36756003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB249;
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
index 1530e37..e789988 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -7291,8 +7291,7 @@ static int cik_irq_init(struct radeon_device *rdev)
 int cik_irq_set(struct radeon_device *rdev)
 {
 	u32 cp_int_cntl;
-	u32 cp_m1p0, cp_m1p1, cp_m1p2, cp_m1p3;
-	u32 cp_m2p0, cp_m2p1, cp_m2p2, cp_m2p3;
+	u32 cp_m1p0;
 	u32 crtc1 = 0, crtc2 = 0, crtc3 = 0, crtc4 = 0, crtc5 = 0, crtc6 = 0;
 	u32 hpd1, hpd2, hpd3, hpd4, hpd5, hpd6;
 	u32 grbm_int_cntl = 0;
@@ -7326,13 +7325,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7354,33 +7346,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7397,33 +7362,6 @@ int cik_irq_set(struct radeon_device *rdev)
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
@@ -7512,13 +7450,6 @@ int cik_irq_set(struct radeon_device *rdev)
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

