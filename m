Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaI3VeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:34:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaI3VcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Chernovskiy <algonkvel@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 013/103] drm/radeon: Add missing lines to ci_set_thermal_temperature_range
Date: Tue, 30 Sep 2014 14:30:18 -0700
Message-Id: <1412112708-27356-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Chernovskiy <algonkvel@gmail.com>

commit 6bce8d9772c1c606921a9c99e566eb14202f6669 upstream.

Properly set the thermal min and max temp on CI.
Otherwise, we end up setting the thermal ranges
to 0 on resume and end up in the lowest power state.

Signed-off-by: Oleg Chernovskiy <algonkvel@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 8bfab60..9c769f7 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -852,6 +852,9 @@ static int ci_set_thermal_temperature_range(struct radeon_device *rdev,
 	WREG32_SMC(CG_THERMAL_CTRL, tmp);
 #endif
 
+	rdev->pm.dpm.thermal.min_temp = low_temp;
+	rdev->pm.dpm.thermal.max_temp = high_temp;
+
 	return 0;
 }
 
-- 
1.9.1

