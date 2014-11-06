Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaKFWog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaKFWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 075/162] drm/radeon: fix speaker allocation setup
Date: Thu,  6 Nov 2014 14:35:39 -0800
Message-Id: <1415313426-9622-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4910403836ded89803fab201d4b5caaa85de3a89 upstream.

If the sad_count is 0, set the hw to stereo and change
the error message to a warn.  A lot of monitors don't
set the speaker allocation block.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.13-stable: no dce3_1_afmt.c in 3.13. ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/dce6_afmt.c      | 6 +++---
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index ff0001c..3483828 100644
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
index 0c6d5ce..738c1ec 100644
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
1.9.1

