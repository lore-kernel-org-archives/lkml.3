Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbaJIVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbaJIVIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 106/163] drm/radeon: don't reset dma on r6xx-evergreen init
Date: Thu,  9 Oct 2014 14:02:11 -0700
Message-Id: <1412888588-26755-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c1789a2e66a4209fe5035eca11fdd729b2ffdd82 upstream.

Otherwise we may lose the DMA golden settings which can
lead to hangs, etc.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/r600_dma.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_dma.c b/drivers/gpu/drm/radeon/r600_dma.c
index 7844d15..616d37a 100644
--- a/drivers/gpu/drm/radeon/r600_dma.c
+++ b/drivers/gpu/drm/radeon/r600_dma.c
@@ -116,15 +116,6 @@ int r600_dma_resume(struct radeon_device *rdev)
 	u32 rb_bufsz;
 	int r;
 
-	/* Reset dma */
-	if (rdev->family >= CHIP_RV770)
-		WREG32(SRBM_SOFT_RESET, RV770_SOFT_RESET_DMA);
-	else
-		WREG32(SRBM_SOFT_RESET, SOFT_RESET_DMA);
-	RREG32(SRBM_SOFT_RESET);
-	udelay(50);
-	WREG32(SRBM_SOFT_RESET, 0);
-
 	WREG32(DMA_SEM_INCOMPLETE_TIMER_CNTL, 0);
 	WREG32(DMA_SEM_WAIT_FAIL_TIMER_CNTL, 0);
 
-- 
1.9.1

