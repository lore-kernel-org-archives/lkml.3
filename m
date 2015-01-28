Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbbA2DRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:17:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46957 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbbA2CgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 079/139] drm/radeon: check the right ring in radeon_evict_flags()
Date: Wed, 28 Jan 2015 14:20:22 -0800
Message-Id: <1422483682-15393-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5e5c21cac1001089007260c48b0c89ebaace0e71 upstream.

Check the that ring we are using for copies is functional
rather than the GFX ring.  On newer asics we use the DMA
ring for bo moves.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 84323c9..02d3c38 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -189,7 +189,7 @@ static void radeon_evict_flags(struct ttm_buffer_object *bo,
 	rbo = container_of(bo, struct radeon_bo, tbo);
 	switch (bo->mem.mem_type) {
 	case TTM_PL_VRAM:
-		if (rbo->rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ready == false)
+		if (rbo->rdev->ring[radeon_copy_ring_index(rbo->rdev)].ready == false)
 			radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_CPU);
 		else
 			radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_GTT);
-- 
1.9.1

