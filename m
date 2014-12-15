Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaLOO2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:28:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaLOO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 049/168] drm/radeon: fix endian swapping in vbios fetch for tdp table
Date: Mon, 15 Dec 2014 14:25:03 +0000
Message-Id: <1418653622-21105-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 28731d5818ae25b92d1fb82fe0ac196e97102c1b upstream.

Value needs to be swapped on BE.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index 9c61b74ef441..e961be55348a 100644
--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -1255,7 +1255,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 					(mode_info->atom_context->bios + data_offset +
 					 le16_to_cpu(ext_hdr->usPowerTuneTableOffset));
 				rdev->pm.dpm.dyn_state.cac_tdp_table->maximum_power_delivery_limit =
-					ppt->usMaximumPowerDeliveryLimit;
+					le16_to_cpu(ppt->usMaximumPowerDeliveryLimit);
 				pt = &ppt->power_tune_table;
 			} else {
 				ATOM_PPLIB_POWERTUNE_Table *ppt = (ATOM_PPLIB_POWERTUNE_Table *)
-- 
2.1.3

