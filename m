Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaGHMhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:37:22 -0400
Received: from gnurou.org ([207.192.72.5]:48217 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbaGHMhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:37:16 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Andrzej Hajda <a.hajda@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 3/4] drm/tegra: dsi - Handle non-continuous clock flag
Date: Tue,  8 Jul 2014 21:32:13 +0900
Message-Id: <1404822734-8603-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
References: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle the MIPI_DSI_CLOCK_NONCONTINUOUS flag and only set TX-only
clock behavior when this flag is present to allow panels requiring
continuous clock mode to operate with this driver.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/tegra/dsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index bd56f2a..eadfeaf 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -474,7 +474,8 @@ static int tegra_output_dsi_enable(struct tegra_output *output)
 	tegra_dsi_writel(dsi, value, DSI_HOST_CONTROL);
 
 	value = tegra_dsi_readl(dsi, DSI_CONTROL);
-	value |= DSI_CONTROL_HS_CLK_CTRL;
+	if (dsi->flags & MIPI_DSI_CLOCK_NON_CONTINUOUS)
+		value |= DSI_CONTROL_HS_CLK_CTRL;
 	value &= ~DSI_CONTROL_TX_TRIG(3);
 	value &= ~DSI_CONTROL_DCS_ENABLE;
 	value |= DSI_CONTROL_VIDEO_ENABLE;
-- 
2.0.0

