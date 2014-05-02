Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaEBPwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:52:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaEBPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 121/151] drm/radeon: clear needs_reset flag if IB test fails
Date: Fri,  2 May 2014 08:38:29 -0700
Message-Id: <1399045139-4531-122-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 06a139f7a0885fa2c84962300edd181821ddc2c9 upstream.

If the IB test fails we don't want to reset the card over
and over again, just accept that it isn't working.

Bug: https://bugs.freedesktop.org/show_bug.cgi?id=76501

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 39a5d8e..5fecf52 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -257,6 +257,7 @@ int radeon_ib_ring_tests(struct radeon_device *rdev)
 		r = radeon_ib_test(rdev, i, ring);
 		if (r) {
 			ring->ready = false;
+			rdev->needs_reset = false;
 
 			if (i == RADEON_RING_TYPE_GFX_INDEX) {
 				/* oh, oh, that's really bad */
-- 
1.9.1

