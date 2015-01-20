Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbbATLDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:03:03 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48097 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbbATKtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:07 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/36] drm/atomic: Add drm_atomic_plane_get_crtc_state()
Date: Tue, 20 Jan 2015 11:48:24 +0100
Message-Id: <1421750935-4023-6-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This function is useful to obtain the state of the CRTC that a plane is
being attached to.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/drm/drm_atomic.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/drm/drm_atomic.h b/include/drm/drm_atomic.h
index 51168a8b723a..ddca107e5cce 100644
--- a/include/drm/drm_atomic.h
+++ b/include/drm/drm_atomic.h
@@ -75,4 +75,25 @@ int __must_check drm_atomic_check_only(struct drm_atomic_state *state);
 int __must_check drm_atomic_commit(struct drm_atomic_state *state);
 int __must_check drm_atomic_async_commit(struct drm_atomic_state *state);
 
+/**
+ * drm_atomic_plane_get_crtc_state - obtain atomic state of the CRTC that a
+ *     plane is being attached to
+ * @state: atomic state of plane
+ *
+ * Getting the atomic state of the CRTC that a given plane being attached to
+ * is non-trivial. We need to look at the global atomic state that the plane
+ * state is part of and extract the CRTC state using the CRTC's index. Using
+ * the drm_atomic_get_crtc_state() helper we make sure to acquire the proper
+ * locks, too.
+ *
+ * RETURNS:
+ * The atomic state of the CRTC that the plane is being attached to, or an
+ * ERR_PTR()-encoded negative error code on failure.
+ */
+static inline struct drm_crtc_state *
+drm_atomic_plane_get_crtc_state(struct drm_plane_state *state)
+{
+	return drm_atomic_get_crtc_state(state->state, state->crtc);
+}
+
 #endif /* DRM_ATOMIC_H_ */
-- 
2.1.3

