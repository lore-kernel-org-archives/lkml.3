Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaFJTxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:53:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaFJTxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/160] drm/radeon: re-enable mclk dpm on R7 260X asics
Date: Tue, 10 Jun 2014 12:44:38 -0700
Message-Id: <1402429600-20477-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 7e1858f9aff7d608b3d0abad4bda0130de887b89 upstream.

If the new mc ucode is available.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index d4ca530..318d226 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -21,8 +21,10 @@
  *
  */
 
+#include <linux/firmware.h>
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_ucode.h"
 #include "cikd.h"
 #include "r600_dpm.h"
 #include "ci_dpm.h"
@@ -5128,9 +5130,11 @@ int ci_dpm_init(struct radeon_device *rdev)
 	pi->mclk_dpm_key_disabled = 0;
 	pi->pcie_dpm_key_disabled = 0;
 
-	/* mclk dpm is unstable on some R7 260X cards */
-	if (rdev->pdev->device == 0x6658)
+	/* mclk dpm is unstable on some R7 260X cards with the old mc ucode */
+	if ((rdev->pdev->device == 0x6658) &&
+	    (rdev->mc_fw->size == (BONAIRE_MC_UCODE_SIZE * 4))) {
 		pi->mclk_dpm_key_disabled = 1;
+	}
 
 	pi->caps_sclk_ds = true;
 
-- 
1.9.1

