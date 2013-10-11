Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab3JKLCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:02:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3JKKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 040/100] drm/radeon: disable tests/benchmarks if accel is disabled
Date: Fri, 11 Oct 2013 11:41:10 +0100
Message-Id: <1381488130-30235-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4a1132a023eb48cf10522d84c5908d43b612c041 upstream.

The tests are only usable if the acceleration engines have
been successfully initialized.

Based on an initial patch from: Alex Ivanov <gnidorah@p0n4ik.tk>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_device.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index d14044e..719702d1 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -834,13 +834,22 @@ int radeon_device_init(struct radeon_device *rdev,
 			return r;
 	}
 	if ((radeon_testing & 1)) {
-		radeon_test_moves(rdev);
+		if (rdev->accel_working)
+			radeon_test_moves(rdev);
+		else
+			DRM_INFO("radeon: acceleration disabled, skipping move tests\n");
 	}
 	if ((radeon_testing & 2)) {
-		radeon_test_syncing(rdev);
+		if (rdev->accel_working)
+			radeon_test_syncing(rdev);
+		else
+			DRM_INFO("radeon: acceleration disabled, skipping sync tests\n");
 	}
 	if (radeon_benchmarking) {
-		radeon_benchmark(rdev, radeon_benchmarking);
+		if (rdev->accel_working)
+			radeon_benchmark(rdev, radeon_benchmarking);
+		else
+			DRM_INFO("radeon: acceleration disabled, skipping benchmarks\n");
 	}
 	return 0;
 }
-- 
1.8.3.2

