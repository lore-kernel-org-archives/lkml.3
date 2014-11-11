Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaKKLJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57241 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaKKLJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 031/170] drm/radeon: fix speaker allocation setup
Date: Tue, 11 Nov 2014 11:06:30 +0000
Message-Id: <1415704129-12709-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4910403836ded89803fab201d4b5caaa85de3a89 upstream.

If the sad_count is 0, set the hw to stereo and change
the error message to a warn.  A lot of monitors don't
set the speaker allocation block.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/dce3_1_afmt.c    | 4 ++--
 drivers/gpu/drm/radeon/dce6_afmt.c      | 6 +++---
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c b/drivers/gpu/drm/radeon/dce3_1_afmt.c
index 51800e340a57..71f4d26669cd 100644
--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -49,8 +49,8 @@ static void dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector->edid, &sadb);
 	if (sad_count < 0) {
-		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
-		return;
+		DRM_DEBUG("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
+		sad_count = 0;
 	}
 
 	/* program the speaker allocation */
diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index 0a65dc7e93e7..ee5da3b56fbf 100644
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -174,9 +174,9 @@ void dce6_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	}
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector->edid, &sadb);
-	if (sad_count <= 0) {
-		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
-		return;
+	if (sad_count < 0) {
+		DRM_DEBUG("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
+		sad_count = 0;
 	}
 
 	/* program the speaker allocation */
diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index 1ec0e6e83f9f..d9c8bb9559a9 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -118,9 +118,9 @@ static void dce4_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	}
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector->edid, &sadb);
-	if (sad_count <= 0) {
-		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
-		return;
+	if (sad_count < 0) {
+		DRM_DEBUG("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
+		sad_count = 0;
 	}
 
 	/* program the speaker allocation */
-- 
2.1.0

