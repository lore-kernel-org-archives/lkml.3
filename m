Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbbA2JJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:09:45 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44942 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932898AbbA2JJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:09:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/176] drm/radeon: check the right ring in radeon_evict_flags()
Date: Wed, 28 Jan 2015 15:28:25 +0100
Message-Id: <c02ca53c957e1731bdd9afa75cdbf2a84c5d8519.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5e5c21cac1001089007260c48b0c89ebaace0e71 upstream.

Check the that ring we are using for copies is functional
rather than the GFX ring.  On newer asics we use the DMA
ring for bo moves.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 84323c943bfc..02d3c3820803 100644
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
2.2.2

