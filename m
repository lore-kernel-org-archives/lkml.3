Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbbALSGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbALSGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 079/216] drm/radeon: check the right ring in radeon_evict_flags()
Date: Mon, 12 Jan 2015 18:03:16 +0000
Message-Id: <1421085933-32536-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5e5c21cac1001089007260c48b0c89ebaace0e71 upstream.

Check the that ring we are using for copies is functional
rather than the GFX ring.  On newer asics we use the DMA
ring for bo moves.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index c8a8a5144ec1..7555349e30da 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -191,7 +191,7 @@ static void radeon_evict_flags(struct ttm_buffer_object *bo,
 	rbo = container_of(bo, struct radeon_bo, tbo);
 	switch (bo->mem.mem_type) {
 	case TTM_PL_VRAM:
-		if (rbo->rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ready == false)
+		if (rbo->rdev->ring[radeon_copy_ring_index(rbo->rdev)].ready == false)
 			radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_CPU);
 		else
 			radeon_ttm_placement_from_domain(rbo, RADEON_GEM_DOMAIN_GTT);
-- 
2.1.4

