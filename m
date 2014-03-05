Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbaCEPQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:16:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaCEOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/131] drm/radeon/ni: fix typo in dpm sq ramping setup
Date: Wed,  5 Mar 2014 14:22:57 +0000
Message-Id: <1394029455-23128-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 21ed4947fdfe19b60a27b84162622e56439c7937 upstream.

inverted logic.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 56d0d95..4c64254 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -2567,7 +2567,7 @@ static int ni_populate_sq_ramping_values(struct radeon_device *rdev,
 	if (NISLANDS_DPM2_SQ_RAMP_STI_SIZE > (STI_SIZE_MASK >> STI_SIZE_SHIFT))
 		enable_sq_ramping = false;
 
-	if (NISLANDS_DPM2_SQ_RAMP_LTI_RATIO <= (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
+	if (NISLANDS_DPM2_SQ_RAMP_LTI_RATIO > (LTI_RATIO_MASK >> LTI_RATIO_SHIFT))
 		enable_sq_ramping = false;
 
 	for (i = 0; i < state->performance_level_count; i++) {
-- 
1.9.0

