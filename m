Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaLCL1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaLCL1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jammy Zhou <Jammy.Zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/101] drm/radeon: set correct CE ram size for CIK
Date: Wed,  3 Dec 2014 12:25:56 +0100
Message-Id: <37dc09565477b5beb644ceea44341fdc46ac4dbe.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jammy Zhou <Jammy.Zhou@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dc4edad6530a9b7b66c3d905e2bc06021a05dcad upstream.

CE ram size is 32k/0k/0k for GFX/CS0/CS1 with CIK

Ported from amdgpu driver.

Signed-off-by: Jammy Zhou <Jammy.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cik.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index ceba819891f4..8cefe1cf7df7 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3343,8 +3343,8 @@ static int cik_cp_gfx_start(struct radeon_device *rdev)
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
2.1.3

