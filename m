Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaDALnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:43:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaDALSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 097/144] drm/radeon/cik: properly set compute ring status on disable
Date: Tue,  1 Apr 2014 12:15:01 +0100
Message-Id: <1396350948-29910-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b2b3d8d952e4f8d6ac2ce80be96b937f29f6e42e upstream.

When we disable the rings, set the status properly.  If
not other code pathes may try and use the rings which are
not functional at this point.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 403aecb..7ab8bdc 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -2676,8 +2676,11 @@ static void cik_cp_compute_enable(struct radeon_device *rdev, bool enable)
 {
 	if (enable)
 		WREG32(CP_MEC_CNTL, 0);
-	else
+	else {
 		WREG32(CP_MEC_CNTL, (MEC_ME1_HALT | MEC_ME2_HALT));
+		rdev->ring[CAYMAN_RING_TYPE_CP1_INDEX].ready = false;
+		rdev->ring[CAYMAN_RING_TYPE_CP2_INDEX].ready = false;
+	}
 	udelay(50);
 }
 
-- 
1.9.1

