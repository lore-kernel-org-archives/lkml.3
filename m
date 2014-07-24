Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529AbaGXJxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:53:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934825AbaGXJtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexandre Demers <alexandre.f.demers@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/128] drm/radeon/dpm: Reenabling SS on Cayman
Date: Thu, 24 Jul 2014 10:46:07 +0100
Message-Id: <1406195177-8656-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Demers <alexandre.f.demers@gmail.com>

commit 41959341ac7e33dd360c7a881d13566f9eca37b2 upstream.

It reverts commit c745fe611ca42295c9d91d8e305d27983e9132ef now that
Cayman is stable since VDDCI fix. Spread spectrum was not the culprit.

This depends on b0880e87c1fd038b84498944f52e52c3e86ebe59
(drm/radeon/dpm: fix vddci setup typo on cayman).

Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/rv770_dpm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index a923ba966a78..a4c4f25c93e6 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2333,12 +2333,6 @@ void rv770_get_engine_memory_ss(struct radeon_device *rdev)
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

