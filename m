Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbbATK5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:57:18 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:57396 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbbATK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:57:14 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/36] drm/tegra: dc: Do not needlessly deassert reset
Date: Tue, 20 Jan 2015 11:48:40 +0100
Message-Id: <1421750935-4023-22-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit 9c0127004ff4 ("drm/tegra: dc: Add powergate support") changed the
driver's ->probe() implementation to deassert the module reset, and with
there being nobody else to assert it until ->remove() there is no need
to deassert again later on.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 462945abded2..846daf48cf61 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1160,10 +1160,6 @@ static void tegra_crtc_prepare(struct drm_crtc *crtc)
 
 	drm_crtc_vblank_off(crtc);
 
-	/* hardware initialization */
-	reset_control_deassert(dc->rst);
-	usleep_range(10000, 20000);
-
 	if (dc->pipe)
 		syncpt = SYNCPT_VBLANK1;
 	else
-- 
2.1.3

