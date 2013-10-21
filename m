Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3JUJPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:15:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39586 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817Ab3JUIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.202807036@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 084/149] drm/radeon: disable tests/benchmarks if accel
 is disabled
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4a1132a023eb48cf10522d84c5908d43b612c041 upstream.

The tests are only usable if the acceleration engines have
been successfully initialized.

Based on an initial patch from: Alex Ivanov <gnidorah@p0n4ik.tk>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: there is only one test: radeon_test_moves()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -818,10 +818,16 @@ int radeon_device_init(struct radeon_dev
 			return r;
 	}
 	if (radeon_testing) {
-		radeon_test_moves(rdev);
+		if (rdev->accel_working)
+			radeon_test_moves(rdev);
+		else
+			DRM_INFO("radeon: acceleration disabled, skipping move tests\n");
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

