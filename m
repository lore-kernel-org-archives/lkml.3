Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaDNWK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:10:58 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:41591 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbaDNWKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:10:54 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: alexander.deucher@amd.com, christian.koenig@amd.com, airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] drm/radeon: fix VCE fence command
Date: Tue, 15 Apr 2014 00:10:22 +0200
Message-Id: <1397513422-1566-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a type mismatch that causes an implicit type conversion, the
upper 32 bits of the GPU address have been zeroed out when adding to the
command buffer.

Picked up by Coverity - CID 1198624.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/gpu/drm/radeon/radeon_vce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_vce.c b/drivers/gpu/drm/radeon/radeon_vce.c
index 76e9904..ced53dd 100644
--- a/drivers/gpu/drm/radeon/radeon_vce.c
+++ b/drivers/gpu/drm/radeon/radeon_vce.c
@@ -613,7 +613,7 @@ void radeon_vce_fence_emit(struct radeon_device *rdev,
 			   struct radeon_fence *fence)
 {
 	struct radeon_ring *ring = &rdev->ring[fence->ring];
-	uint32_t addr = rdev->fence_drv[fence->ring].gpu_addr;
+	uint64_t addr = rdev->fence_drv[fence->ring].gpu_addr;
 
 	radeon_ring_write(ring, VCE_CMD_FENCE);
 	radeon_ring_write(ring, addr);
-- 
1.9.0

