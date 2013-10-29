Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3J2SY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:24:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3J2SFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 12/81] drm/radeon: forever loop on error in radeon_do_test_moves()
Date: Tue, 29 Oct 2013 11:03:33 -0700
Message-Id: <1383069882-11437-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 89cd67b326fa95872cc2b4524cd807128db6071d upstream.

The error path does this:

	for (--i; i >= 0; --i) {

which is a forever loop because "i" is unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_test.c b/drivers/gpu/drm/radeon/radeon_test.c
index fda09c9..91bec65 100644
--- a/drivers/gpu/drm/radeon/radeon_test.c
+++ b/drivers/gpu/drm/radeon/radeon_test.c
@@ -37,8 +37,8 @@ static void radeon_do_test_moves(struct radeon_device *rdev, int flag)
 	struct radeon_bo **gtt_obj = NULL;
 	struct radeon_fence *fence = NULL;
 	uint64_t gtt_addr, vram_addr;
-	unsigned i, n, size;
-	int r, ring;
+	unsigned n, size;
+	int i, r, ring;
 
 	switch (flag) {
 	case RADEON_TEST_COPY_DMA:
-- 
1.8.1.2

