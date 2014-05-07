Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbaEGNOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:14:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45429 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893AbaEGNOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 18/70] drm/radeon: fix count in cik_sdma_ring_test()
Date: Wed,  7 May 2014 14:12:21 +0100
Message-Id: <1399468393-10140-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 7e95cfb0b797678cd3493ca0322ef2675547a0bc upstream.

Should be 5 rather than 4.

Noticed-by: Mathias Fröhlich <Mathias.Froehlich@gmx.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
[ luis: backported to 3.11:
  - cik_sdma_ring_test() defined in cik.c instead of cik_sdma.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index bf96acf..986537b 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3690,7 +3690,7 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
 	tmp = 0xCAFEDEAD;
 	writel(tmp, ptr);
 
-	r = radeon_ring_lock(rdev, ring, 4);
+	r = radeon_ring_lock(rdev, ring, 5);
 	if (r) {
 		DRM_ERROR("radeon: dma failed to lock ring %d (%d).\n", ring->idx, r);
 		return r;
-- 
1.9.1

