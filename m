Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbaIOWQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:16:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50900 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbaIOWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:15:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Andreas Boll <andreas.boll.dev@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 159/187] drm/radeon: tweak ACCEL_WORKING2 query for hawaii
Date: Mon, 15 Sep 2014 15:09:29 -0700
Message-Id: <1410818997-9432-160-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c64bd26f7e9bd589ebe0d1ebec69ef2f784c12d upstream.

Return 2 so we can be sure the kernel has the necessary
changes for acceleration to work.

Note: This patch depends on these two commits:
 - drm/radeon: fix cut and paste issue for hawaii.
 - drm/radeon: use packet2 for nop on hawaii with old firmware

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Andreas Boll <andreas.boll.dev@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 5ef56ad..ecffe85 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -254,7 +254,14 @@ int radeon_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 		}
 		break;
 	case RADEON_INFO_ACCEL_WORKING2:
-		*value = rdev->accel_working;
+		if (rdev->family == CHIP_HAWAII) {
+			if (rdev->accel_working)
+				*value = 2;
+			else
+				*value = 0;
+		} else {
+			*value = rdev->accel_working;
+		}
 		break;
 	case RADEON_INFO_TILING_CONFIG:
 		if (rdev->family >= CHIP_BONAIRE)
-- 
1.9.1

