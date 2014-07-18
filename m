Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161290AbaGRNWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:22:17 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17969 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030817AbaGRNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 162/170] drm/radeon: fix typo in ci_stop_dpm()
Date: Fri, 18 Jul 2014 14:12:47 +0200
Message-Id: <26fa71a7d3f02fc7977ccd458d38535aa8d905b2.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ed96377132e564d797c48a5490fd46bed01c4273 upstream.

Need to use the RREG32_SMC() accessor since the register
is an smc indirect index.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 79682ff51b63..78e25d2e2fc4 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -1130,7 +1130,7 @@ static int ci_stop_dpm(struct radeon_device *rdev)
 	tmp &= ~GLOBAL_PWRMGT_EN;
 	WREG32_SMC(GENERAL_PWRMGT, tmp);
 
-	tmp = RREG32(SCLK_PWRMGT_CNTL);
+	tmp = RREG32_SMC(SCLK_PWRMGT_CNTL);
 	tmp &= ~DYNAMIC_PM_EN;
 	WREG32_SMC(SCLK_PWRMGT_CNTL, tmp);
 
-- 
2.0.0

