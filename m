Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3G3PSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:18:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 15/75] drm/radeon: allocate SA bo in the requested domain
Date: Tue, 30 Jul 2013 08:16:44 -0700
Message-Id: <1375197464-27962-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 7220f639c2eca36774dbf65b16fe503bfb40fff5 upstream.

This avoid moving the BO directly after allocating it.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: 3.8.y-stable prereq for:
  6c4f978 "drm/radeon: allow selection of alignment in the sub-allocator" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_sa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_sa.c b/drivers/gpu/drm/radeon/radeon_sa.c
index cb80099..0abe5a9 100644
--- a/drivers/gpu/drm/radeon/radeon_sa.c
+++ b/drivers/gpu/drm/radeon/radeon_sa.c
@@ -64,7 +64,7 @@ int radeon_sa_bo_manager_init(struct radeon_device *rdev,
 	}
 
 	r = radeon_bo_create(rdev, size, RADEON_GPU_PAGE_SIZE, true,
-			     RADEON_GEM_DOMAIN_CPU, NULL, &sa_manager->bo);
+			     domain, NULL, &sa_manager->bo);
 	if (r) {
 		dev_err(rdev->dev, "(%d) failed to allocate bo for manager\n", r);
 		return r;
-- 
1.8.1.2

