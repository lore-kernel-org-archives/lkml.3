Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161253AbaGRNTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:19:41 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:18015 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161231AbaGRNTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:19:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/170] drm/radeon: fix typo in radeon_connector_is_dp12_capable()
Date: Fri, 18 Jul 2014 14:11:25 +0200
Message-Id: <d437f862f098aea2d30df01b3a550526d57d8ad0.1405685481.git.jslaby@suse.cz>
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

commit af5d36539dfe043f1cf0f8b7334d6bb12cd14e75 upstream.

We were checking the ext clock rather than the display clock.

Noticed by ArtForz on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 64565732cb98..fe90b3e28d88 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1360,7 +1360,7 @@ bool radeon_connector_is_dp12_capable(struct drm_connector *connector)
 	struct radeon_device *rdev = dev->dev_private;
 
 	if (ASIC_IS_DCE5(rdev) &&
-	    (rdev->clock.dp_extclk >= 53900) &&
+	    (rdev->clock.default_dispclk >= 53900) &&
 	    radeon_connector_encoder_is_hbr2(connector)) {
 		return true;
 	}
-- 
2.0.0

