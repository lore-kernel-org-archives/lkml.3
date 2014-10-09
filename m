Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaJIV3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:29:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbaJIVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 104/163] drm/radeon: don't reset dma on NI/SI init
Date: Thu,  9 Oct 2014 14:02:09 -0700
Message-Id: <1412888588-26755-105-git-send-email-kamal@canonical.com>
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

commit 31a25e2caf9367365fcb0e57fd8fa5a42e9b73e4 upstream.

Otherwise we may lose the DMA golden settings which can
lead to hangs, etc.

bug:
https://www.libreoffice.org/bugzilla/show_bug.cgi?id=83500

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ni_dma.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni_dma.c b/drivers/gpu/drm/radeon/ni_dma.c
index bdeb65e..ddc946b 100644
--- a/drivers/gpu/drm/radeon/ni_dma.c
+++ b/drivers/gpu/drm/radeon/ni_dma.c
@@ -120,12 +120,6 @@ int cayman_dma_resume(struct radeon_device *rdev)
 	u32 reg_offset, wb_offset;
 	int i, r;
 
-	/* Reset dma */
-	WREG32(SRBM_SOFT_RESET, SOFT_RESET_DMA | SOFT_RESET_DMA1);
-	RREG32(SRBM_SOFT_RESET);
-	udelay(50);
-	WREG32(SRBM_SOFT_RESET, 0);
-
 	for (i = 0; i < 2; i++) {
 		if (i == 0) {
 			ring = &rdev->ring[R600_RING_TYPE_DMA_INDEX];
-- 
1.9.1

