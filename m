Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab3HQAas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:30:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3HPWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 017/133] drm/radeon: improve dac adjust heuristics for legacy pdac
Date: Fri, 16 Aug 2013 15:32:39 -0700
Message-Id: <1376692475-28413-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 03ed8cf9b28d886c64c7e705c7bb1a365fd8fb95 upstream.

Hopefully avoid more quirks in the future due to bogus
vbios dac data.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 8528b81..485f82c 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -965,8 +965,10 @@ struct radeon_encoder_primary_dac *radeon_combios_get_primary_dac_info(struct
 			dac = RBIOS8(dac_info + 0x3) & 0xf;
 			p_dac->ps2_pdac_adj = (bg << 8) | (dac);
 		}
-		/* if the values are all zeros, use the table */
-		if (p_dac->ps2_pdac_adj)
+		/* if the values are zeros, use the table */
+		if ((dac == 0) || (bg == 0))
+			found = 0;
+		else
 			found = 1;
 	}
 
-- 
1.8.1.2

