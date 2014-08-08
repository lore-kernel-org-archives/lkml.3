Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbaHHVDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:03:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbaHHUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexandre Demers <alexandre.f.demers@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 096/259] drm/radeon/dpm: Reenabling SS on Cayman
Date: Fri,  8 Aug 2014 13:38:39 -0700
Message-Id: <1407530482-4483-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Demers <alexandre.f.demers@gmail.com>

commit 41959341ac7e33dd360c7a881d13566f9eca37b2 upstream.

It reverts commit c745fe611ca42295c9d91d8e305d27983e9132ef now that
Cayman is stable since VDDCI fix. Spread spectrum was not the culprit.

This depends on b0880e87c1fd038b84498944f52e52c3e86ebe59
(drm/radeon/dpm: fix vddci setup typo on cayman).

Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/rv770_dpm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index a239b30..890cf17 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2328,12 +2328,6 @@ void rv770_get_engine_memory_ss(struct radeon_device *rdev)
 	pi->mclk_ss = radeon_atombios_get_asic_ss_info(rdev, &ss,
 						       ASIC_INTERNAL_MEMORY_SS, 0);
 
-	/* disable ss, causes hangs on some cayman boards */
-	if (rdev->family == CHIP_CAYMAN) {
-		pi->sclk_ss = false;
-		pi->mclk_ss = false;
-	}
-
 	if (pi->sclk_ss || pi->mclk_ss)
 		pi->dynamic_ss = true;
 	else
-- 
1.9.1

