Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3G3Jch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3G3Jcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 020/106] drm/radeon/hdmi: make sure we have an afmt block assigned
Date: Tue, 30 Jul 2013 10:30:39 +0100
Message-Id: <1375176725-5825-21-git-send-email-luis.henriques@canonical.com>
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

commit c2b4cacfe9816c1fe378c785ce8a678cf0635ec6 upstream.

Prevents a segfault if an afmt block is not assigned to the
encoder such as in the LVDS or eDP case.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=66714

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.5:
  - adjusted context
  - dropped changes to evergreen_hdmi_enable() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 3 +++
 drivers/gpu/drm/radeon/r600_hdmi.c      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index 65c5416..44b3b07 100644
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
index 26ce6c1..949bf83 100644
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
1.8.3.2

