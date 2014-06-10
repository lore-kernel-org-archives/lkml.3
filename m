Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaFJTrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:47:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaFJTrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 075/160] drm/radeon: fix count in cik_sdma_ring_test()
Date: Tue, 10 Jun 2014 12:45:15 -0700
Message-Id: <1402429600-20477-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 7e95cfb0b797678cd3493ca0322ef2675547a0bc upstream.

Should be 5 rather than 4.

Noticed-by: Mathias Fröhlich <Mathias.Froehlich@gmx.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik_sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index 2e0c7a8..d528dcf 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -526,7 +526,7 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
 	tmp = 0xCAFEDEAD;
 	writel(tmp, ptr);
 
-	r = radeon_ring_lock(rdev, ring, 4);
+	r = radeon_ring_lock(rdev, ring, 5);
 	if (r) {
 		DRM_ERROR("radeon: dma failed to lock ring %d (%d).\n", ring->idx, r);
 		return r;
-- 
1.9.1

