Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbaJIVge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:36:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59226 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbaJIVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 105/163] drm/radeon: don't reset sdma on CIK init
Date: Thu,  9 Oct 2014 14:02:10 -0700
Message-Id: <1412888588-26755-106-git-send-email-kamal@canonical.com>
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

commit 799028d5d85384cce140323be633c8d5f079193f upstream.

Otherwise we may lose the DMA golden settings which can
lead to hangs, etc.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik_sdma.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index d528dcf..9fd95c7 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -388,13 +388,6 @@ int cik_sdma_resume(struct radeon_device *rdev)
 {
 	int r;
 
-	/* Reset dma */
-	WREG32(SRBM_SOFT_RESET, SOFT_RESET_SDMA | SOFT_RESET_SDMA1);
-	RREG32(SRBM_SOFT_RESET);
-	udelay(50);
-	WREG32(SRBM_SOFT_RESET, 0);
-	RREG32(SRBM_SOFT_RESET);
-
 	r = cik_sdma_load_microcode(rdev);
 	if (r)
 		return r;
-- 
1.9.1

