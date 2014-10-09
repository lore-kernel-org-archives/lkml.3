Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaJIVql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:46:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaJIVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 139/163] drm/radeon/cik: use a separate counter for CP init timeout
Date: Thu,  9 Oct 2014 14:02:44 -0700
Message-Id: <1412888588-26755-140-git-send-email-kamal@canonical.com>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 370ce45b5986118fa496dddbcd7039e1aa1a418f upstream.

Otherwise we may fail to init the second compute ring.

Noticed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 4c5828b..e54f8da 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4327,7 +4327,7 @@ struct bonaire_mqd
  */
 static int cik_cp_compute_resume(struct radeon_device *rdev)
 {
-	int r, i, idx;
+	int r, i, j, idx;
 	u32 tmp;
 	bool use_doorbell = true;
 	u64 hqd_gpu_addr;
@@ -4446,7 +4446,7 @@ static int cik_cp_compute_resume(struct radeon_device *rdev)
 		mqd->queue_state.cp_hqd_pq_wptr= 0;
 		if (RREG32(CP_HQD_ACTIVE) & 1) {
 			WREG32(CP_HQD_DEQUEUE_REQUEST, 1);
-			for (i = 0; i < rdev->usec_timeout; i++) {
+			for (j = 0; j < rdev->usec_timeout; j++) {
 				if (!(RREG32(CP_HQD_ACTIVE) & 1))
 					break;
 				udelay(1);
-- 
1.9.1

