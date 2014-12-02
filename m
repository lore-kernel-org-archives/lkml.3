Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbaLBTzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:55:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaLBTVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:21:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jammy Zhou <Jammy.Zhou@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 061/121] drm/radeon: set correct CE ram size for CIK
Date: Tue,  2 Dec 2014 11:19:00 -0800
Message-Id: <1417548000-1794-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jammy Zhou <Jammy.Zhou@amd.com>

commit dc4edad6530a9b7b66c3d905e2bc06021a05dcad upstream.

CE ram size is 32k/0k/0k for GFX/CS0/CS1 with CIK

Ported from amdgpu driver.

Signed-off-by: Jammy Zhou <Jammy.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index e54f8da..927d523 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3905,8 +3905,8 @@ static int cik_cp_gfx_start(struct radeon_device *rdev)
 	/* init the CE partitions.  CE only used for gfx on CIK */
 	radeon_ring_write(ring, PACKET3(PACKET3_SET_BASE, 2));
 	radeon_ring_write(ring, PACKET3_BASE_INDEX(CE_PARTITION_BASE));
-	radeon_ring_write(ring, 0xc000);
-	radeon_ring_write(ring, 0xc000);
+	radeon_ring_write(ring, 0x8000);
+	radeon_ring_write(ring, 0x8000);
 
 	/* setup clear context state */
 	radeon_ring_write(ring, PACKET3(PACKET3_PREAMBLE_CNTL, 0));
-- 
1.9.1

