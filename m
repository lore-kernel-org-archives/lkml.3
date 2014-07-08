Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaGHMhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:37:17 -0400
Received: from gnurou.org ([207.192.72.5]:48211 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbaGHMhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:37:14 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Andrzej Hajda <a.hajda@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 2/4] drm/panel: Set non-continuous clock flag on supporting panels
Date: Tue,  8 Jul 2014 21:32:12 +0900
Message-Id: <1404822734-8603-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
References: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LG LD070WX3-SL01 and Panasonic VVX10F004B00 are DSI support
non-continuous clock mode. Set the MIPI_DSI_CLOCK_NON_CONTINUOUS
to their definition so host drivers become aware of this capability.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a251361..869a84e3 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -545,7 +545,7 @@ static const struct panel_desc_dsi lg_ld070wx3_sl01 = {
 			.height = 151,
 		},
 	},
-	.flags = MIPI_DSI_MODE_VIDEO,
+	.flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_CLOCK_NON_CONTINUOUS,
 	.format = MIPI_DSI_FMT_RGB888,
 	.lanes = 4,
 };
@@ -599,7 +599,8 @@ static const struct panel_desc_dsi panasonic_vvx10f004b00 = {
 			.height = 136,
 		},
 	},
-	.flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE,
+	.flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
+		 MIPI_DSI_CLOCK_NON_CONTINUOUS,
 	.format = MIPI_DSI_FMT_RGB888,
 	.lanes = 4,
 };
-- 
2.0.0

