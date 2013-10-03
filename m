Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3JCEVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:21:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab3JCEVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:21:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 52/57] drm/radeon: disable tests/benchmarks if accel is disabled
Date: Wed,  2 Oct 2013 21:09:18 -0700
Message-Id: <20131003040640.153611862@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4a1132a023eb48cf10522d84c5908d43b612c041 upstream.

The tests are only usable if the acceleration engines have
been successfully initialized.

Based on an initial patch from: Alex Ivanov <gnidorah@p0n4ik.tk>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_device.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1297,13 +1297,22 @@ int radeon_device_init(struct radeon_dev
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


