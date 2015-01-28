Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764152AbbA2DWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:22:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900AbbA2Cfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:43 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 041/139] drm/radeon: work around a hw bug in MGCG on CIK
Date: Wed, 28 Jan 2015 14:19:44 -0800
Message-Id: <1422483682-15393-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4bb62c95a7e781a238b2ab374f34b1bf91e01ddc upstream.

Always need to set bit 0 of RLC_CGTT_MGCG_OVERRIDE
to avoid unreliable doorbell updates in some cases.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 642eed1..e205912 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5676,6 +5676,7 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 		}
 
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
+		data |= 0x00000001;
 		data &= 0xfffffffd;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
@@ -5707,7 +5708,7 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 		}
 	} else {
 		orig = data = RREG32(RLC_CGTT_MGCG_OVERRIDE);
-		data |= 0x00000002;
+		data |= 0x00000003;
 		if (orig != data)
 			WREG32(RLC_CGTT_MGCG_OVERRIDE, data);
 
-- 
1.9.1

