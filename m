Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaJIVIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbaJIVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 037/163] drm/radeon: fix semaphore value init
Date: Thu,  9 Oct 2014 14:01:02 -0700
Message-Id: <1412888588-26755-38-git-send-email-kamal@canonical.com>
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

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit f229407da79315c18a2f25f485e1a1b9fdda1e92 upstream.

Semaphore values have 64 bits, not 32. This fixes a very subtle bug
that disables synchronization when the upper 32bits wasn't zero.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-By: Grigori Goronzy <greg@chown.ath.cx>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_semaphore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_semaphore.c b/drivers/gpu/drm/radeon/radeon_semaphore.c
index 9006b32..eb7b600 100644
--- a/drivers/gpu/drm/radeon/radeon_semaphore.c
+++ b/drivers/gpu/drm/radeon/radeon_semaphore.c
@@ -34,7 +34,7 @@
 int radeon_semaphore_create(struct radeon_device *rdev,
 			    struct radeon_semaphore **semaphore)
 {
-	uint32_t *cpu_addr;
+	uint64_t *cpu_addr;
 	int i, r;
 
 	*semaphore = kmalloc(sizeof(struct radeon_semaphore), GFP_KERNEL);
-- 
1.9.1

