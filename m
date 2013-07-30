Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3G3P1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:27:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 14/75] drm/radeon/hdmi: make sure we have an afmt block assigned
Date: Tue, 30 Jul 2013 08:16:43 -0700
Message-Id: <1375197464-27962-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c2b4cacfe9816c1fe378c785ce8a678cf0635ec6 upstream.

Prevents a segfault if an afmt block is not assigned to the
encoder such as in the LVDS or eDP case.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=66714

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 3 +++
 drivers/gpu/drm/radeon/r600_hdmi.c      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index 327c08b..3057181 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -156,6 +156,9 @@ void evergreen_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	uint32_t offset;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (!dig->afmt->enabled)
 		return;
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index d89a1f8..79e3cda 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -322,6 +322,9 @@ void r600_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode *mod
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	uint32_t offset;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (!dig->afmt->enabled)
 		return;
@@ -480,6 +483,9 @@ void r600_hdmi_enable(struct drm_encoder *encoder)
 	uint32_t offset;
 	u32 hdmi;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	if (ASIC_IS_DCE6(rdev))
 		return;
 
-- 
1.8.1.2

