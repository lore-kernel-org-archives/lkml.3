Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbaHHUuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:50:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270AbaHHUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:49:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 044/259] drm/radeon/dpm: fix typo in vddci setup for eg/btc
Date: Fri,  8 Aug 2014 13:37:47 -0700
Message-Id: <1407530482-4483-45-git-send-email-kamal@canonical.com>
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

commit e07929810f0a19ddd756558290c7d72827cbfcd9 upstream.

We were using the vddc mask rather than the vddci mask.

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=79071

Possibly also fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=68571

Noticed-by:  Jonathan Howard <jonathan@unbiased.name>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cypress_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cypress_dpm.c b/drivers/gpu/drm/radeon/cypress_dpm.c
index 920e1e4..b5a0077 100644
--- a/drivers/gpu/drm/radeon/cypress_dpm.c
+++ b/drivers/gpu/drm/radeon/cypress_dpm.c
@@ -1551,7 +1551,7 @@ int cypress_populate_smc_voltage_tables(struct radeon_device *rdev,
 
 		table->voltageMaskTable.highMask[RV770_SMC_VOLTAGEMASK_VDDCI] = 0;
 		table->voltageMaskTable.lowMask[RV770_SMC_VOLTAGEMASK_VDDCI] =
-			cpu_to_be32(eg_pi->vddc_voltage_table.mask_low);
+			cpu_to_be32(eg_pi->vddci_voltage_table.mask_low);
 	}
 
 	return 0;
-- 
1.9.1

