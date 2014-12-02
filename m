Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbaLBTmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:42:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46849 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaLBTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:25:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 118/121] drm/radeon: fix endian swapping in vbios fetch for tdp table
Date: Tue,  2 Dec 2014 11:19:57 -0800
Message-Id: <1417548000-1794-119-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 28731d5818ae25b92d1fb82fe0ac196e97102c1b upstream.

Value needs to be swapped on BE.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/r600_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index 2df683a..cc4258a 100644
--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -1193,7 +1193,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 					(mode_info->atom_context->bios + data_offset +
 					 le16_to_cpu(ext_hdr->usPowerTuneTableOffset));
 				rdev->pm.dpm.dyn_state.cac_tdp_table->maximum_power_delivery_limit =
-					ppt->usMaximumPowerDeliveryLimit;
+					le16_to_cpu(ppt->usMaximumPowerDeliveryLimit);
 				pt = &ppt->power_tune_table;
 			} else {
 				ATOM_PPLIB_POWERTUNE_Table *ppt = (ATOM_PPLIB_POWERTUNE_Table *)
-- 
1.9.1

