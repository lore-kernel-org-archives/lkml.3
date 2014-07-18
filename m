Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966AbaGRNb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:31:27 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17826 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161102AbaGRNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 161/170] drm/radeon/dpm: Reenabling SS on Cayman
Date: Fri, 18 Jul 2014 14:12:46 +0200
Message-Id: <998d7902cafec17e94f0ad6cd8126c5764342939.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Demers <alexandre.f.demers@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 41959341ac7e33dd360c7a881d13566f9eca37b2 upstream.

It reverts commit c745fe611ca42295c9d91d8e305d27983e9132ef now that
Cayman is stable since VDDCI fix. Spread spectrum was not the culprit.

This depends on b0880e87c1fd038b84498944f52e52c3e86ebe59
(drm/radeon/dpm: fix vddci setup typo on cayman).

Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/rv770_dpm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index a239b30aaf9d..890cf1710253 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2328,12 +2328,6 @@ void rv770_get_engine_memory_ss(struct radeon_device *rdev)
 	pi->mclk_ss = radeon_atombios_get_asic_ss_info(rdev, &ss,
 						       ASIC_INTERNAL_MEMORY_SS, 0);
 
-	/* disable ss, causes hangs on some cayman boards */
-	if (rdev->family == CHIP_CAYMAN) {
-		pi->sclk_ss = false;
-		pi->mclk_ss = false;
-	}
-
 	if (pi->sclk_ss || pi->mclk_ss)
 		pi->dynamic_ss = true;
 	else
-- 
2.0.0

