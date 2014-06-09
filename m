Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaFIJJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:09:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58457 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754903AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/146] drm/radeon: fix count in cik_sdma_ring_test()
Date: Mon,  9 Jun 2014 10:49:43 +0200
Message-Id: <6ddad49e6f812dbcb68b41875375a259c1ae9e70.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7e95cfb0b797678cd3493ca0322ef2675547a0bc upstream.

Should be 5 rather than 4.

Noticed-by: Mathias Fröhlich <Mathias.Froehlich@gmx.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cik_sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index d565f4076a23..0c6784f52410 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -512,7 +512,7 @@ int cik_sdma_ring_test(struct radeon_device *rdev,
 	tmp = 0xCAFEDEAD;
 	writel(tmp, ptr);
 
-	r = radeon_ring_lock(rdev, ring, 4);
+	r = radeon_ring_lock(rdev, ring, 5);
 	if (r) {
 		DRM_ERROR("radeon: dma failed to lock ring %d (%d).\n", ring->idx, r);
 		return r;
-- 
1.9.3

