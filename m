Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbbATKxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:53:47 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:61206 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbbATKtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:50 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/36] drm/tegra: Atomic conversion, phase 3, step 2
Date: Tue, 20 Jan 2015 11:48:50 +0100
Message-Id: <1421750935-4023-32-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Replace drm_crtc_helper_set_config() by drm_atomic_helper_set_config().
All drivers have now been converted to use ->atomic_check() to set the
atomic state, therefore the atomic mode setting helpers can be used.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index b4a2a17caf05..9a934a6077a6 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1064,7 +1064,7 @@ static void tegra_crtc_atomic_destroy_state(struct drm_crtc *crtc,
 
 static const struct drm_crtc_funcs tegra_crtc_funcs = {
 	.page_flip = tegra_dc_page_flip,
-	.set_config = drm_crtc_helper_set_config,
+	.set_config = drm_atomic_helper_set_config,
 	.destroy = tegra_dc_destroy,
 	.reset = tegra_crtc_reset,
 	.atomic_duplicate_state = tegra_crtc_atomic_duplicate_state,
-- 
2.1.3

