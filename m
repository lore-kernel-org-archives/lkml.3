Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbaHHVGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:06:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046AbaHHUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/259] drm/radeon: fix typo in ci_stop_dpm()
Date: Fri,  8 Aug 2014 13:38:38 -0700
Message-Id: <1407530482-4483-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ed96377132e564d797c48a5490fd46bed01c4273 upstream.

Need to use the RREG32_SMC() accessor since the register
is an smc indirect index.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 318d226..ca13ab5 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -1162,7 +1162,7 @@ static int ci_stop_dpm(struct radeon_device *rdev)
 	tmp &= ~GLOBAL_PWRMGT_EN;
 	WREG32_SMC(GENERAL_PWRMGT, tmp);
 
-	tmp = RREG32(SCLK_PWRMGT_CNTL);
+	tmp = RREG32_SMC(SCLK_PWRMGT_CNTL);
 	tmp &= ~DYNAMIC_PM_EN;
 	WREG32_SMC(SCLK_PWRMGT_CNTL, tmp);
 
-- 
1.9.1

