Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbbALSFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57457 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbbALSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 039/216] drm/radeon: work around a hw bug in MGCG on CIK
Date: Mon, 12 Jan 2015 18:02:36 +0000
Message-Id: <1421085933-32536-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4bb62c95a7e781a238b2ab374f34b1bf91e01ddc upstream.

Always need to set bit 0 of RLC_CGTT_MGCG_OVERRIDE
to avoid unreliable doorbell updates in some cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 6f015436e51d..8d391b51cedc 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5979,6 +5979,7 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 		}
 
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
+		data |= 0x00000001;
 		data &= 0xfffffffd;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
@@ -6010,7 +6011,7 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 		}
 	} else {
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
-		data |= 0x00000002;
+		data |= 0x00000003;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
 
-- 
2.1.4

