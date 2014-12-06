Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaLFPXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:23:31 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47704 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752067AbaLFPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 62/66] drm/radeon: fix endian swapping in vbios fetch for tdp table
Date: Sat,  6 Dec 2014 16:07:54 +0100
Message-Id: <14d7ed4da86b540486d78ce119106afb5666ea76.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 28731d5818ae25b92d1fb82fe0ac196e97102c1b upstream.

Value needs to be swapped on BE.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/r600_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index 2df683aab9e9..cc4258a853fd 100644
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
2.1.3

