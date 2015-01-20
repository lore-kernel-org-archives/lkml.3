Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbbATLEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:04:48 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64440 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbbATKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:02 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/36] drm/plane: Make ->atomic_update() mandatory
Date: Tue, 20 Jan 2015 11:48:21 +0100
Message-Id: <1421750935-4023-3-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

There is no use-case where it would be useful for drivers not to
implement this function and the transitional plane helpers already
require drivers to provide an implementation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/drm_atomic_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index d467185f7942..010661f23035 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1108,7 +1108,7 @@ void drm_atomic_helper_commit_planes(struct drm_device *dev,
 
 		funcs = plane->helper_private;
 
-		if (!funcs || !funcs->atomic_update)
+		if (!funcs)
 			continue;
 
 		old_plane_state = old_state->plane_states[i];
-- 
2.1.3

