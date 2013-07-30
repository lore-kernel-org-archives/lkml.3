Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab3G3Jdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:33:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3G3Jdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 083/106] drm/radeon: improve dac adjust heuristics for legacy pdac
Date: Tue, 30 Jul 2013 10:31:42 +0100
Message-Id: <1375176725-5825-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 03ed8cf9b28d886c64c7e705c7bb1a365fd8fb95 upstream.

Hopefully avoid more quirks in the future due to bogus
vbios dac data.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index f44dc93..be9be8e 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -953,8 +953,10 @@ struct radeon_encoder_primary_dac *radeon_combios_get_primary_dac_info(struct
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
1.8.3.2

