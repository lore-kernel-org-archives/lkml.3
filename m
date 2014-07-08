Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaGHMhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:37:13 -0400
Received: from gnurou.org ([207.192.72.5]:48207 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaGHMhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:37:11 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Andrzej Hajda <a.hajda@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 1/4] drm/dsi: Flag for non-continuous clock behavior
Date: Tue,  8 Jul 2014 21:32:11 +0900
Message-Id: <1404822734-8603-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
References: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per section 5.6.1 of the DSI specification, all DSI transmitters must
support continuous clock behavior on the clock lane, while non-continuous
mode support is only optional. Add a flag that allows devices to indicate
that they support non-continuous clock mode so host drivers can adapt
their behavior accordingly.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 include/drm/drm_mipi_dsi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 944f33f..efa1b55 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -94,6 +94,8 @@ void mipi_dsi_host_unregister(struct mipi_dsi_host *host);
 #define MIPI_DSI_MODE_VSYNC_FLUSH	BIT(8)
 /* disable EoT packets in HS mode */
 #define MIPI_DSI_MODE_EOT_PACKET	BIT(9)
+/* device supports non-continuous clock behavior (DSI spec 5.6.1) */
+#define MIPI_DSI_CLOCK_NON_CONTINUOUS	BIT(10)
 
 enum mipi_dsi_pixel_format {
 	MIPI_DSI_FMT_RGB888,
-- 
2.0.0

