Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865AbaGVWhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:37:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44770 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300AbaGVW0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 048/116] drm/radeon: fix typo in radeon_connector_is_dp12_capable()
Date: Tue, 22 Jul 2014 15:20:59 -0700
Message-Id: <1406067727-19683-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit af5d36539dfe043f1cf0f8b7334d6bb12cd14e75 upstream.

We were checking the ext clock rather than the display clock.

Noticed by ArtForz on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 5a87c9f..fc604fc 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1345,7 +1345,7 @@ bool radeon_connector_is_dp12_capable(struct drm_connector *connector)
 	struct radeon_device *rdev = dev->dev_private;
 
 	if (ASIC_IS_DCE5(rdev) &&
-	    (rdev->clock.dp_extclk >= 53900) &&
+	    (rdev->clock.default_dispclk >= 53900) &&
 	    radeon_connector_encoder_is_hbr2(connector)) {
 		return true;
 	}
-- 
1.9.1

