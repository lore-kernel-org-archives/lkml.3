Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966338AbaFQWNC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:13:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54589 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966821AbaFQVvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 200/212] drm/radeon: use the CP DMA on CIK
Date: Tue, 17 Jun 2014 14:44:54 -0700
Message-Id: <1403041506-13646-201-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 91b0275c0ecd1870c5f8bfb73e2da2d6c29414b3 upstream.

The SDMA sometimes doesn't seem to work reliable.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_asic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_asic.c b/drivers/gpu/drm/radeon/radeon_asic.c
index c0425bb..552edbd 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -2025,8 +2025,8 @@ static struct radeon_asic ci_asic = {
 		.blit_ring_index = RADEON_RING_TYPE_GFX_INDEX,
 		.dma = &cik_copy_dma,
 		.dma_ring_index = R600_RING_TYPE_DMA_INDEX,
-		.copy = &cik_copy_dma,
-		.copy_ring_index = R600_RING_TYPE_DMA_INDEX,
+		.copy = &cik_copy_cpdma,
+		.copy_ring_index = RADEON_RING_TYPE_GFX_INDEX,
 	},
 	.surface = {
 		.set_reg = r600_set_surface_reg,
-- 
1.9.1

