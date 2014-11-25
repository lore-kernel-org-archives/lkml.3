Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaKYLHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:07:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaKYKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jammy Zhou <Jammy.Zhou@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 177/254] drm/radeon: set correct CE ram size for CIK
Date: Tue, 25 Nov 2014 10:38:47 +0000
Message-Id: <1416912004-5928-178-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jammy Zhou <Jammy.Zhou@amd.com>

commit dc4edad6530a9b7b66c3d905e2bc06021a05dcad upstream.

CE ram size is 32k/0k/0k for GFX/CS0/CS1 with CIK

Ported from amdgpu driver.

Signed-off-by: Jammy Zhou <Jammy.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 5ea01de617ab..180f2638c9cc 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4035,8 +4035,8 @@ static int cik_cp_gfx_start(struct radeon_device *rdev)
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
2.1.0

