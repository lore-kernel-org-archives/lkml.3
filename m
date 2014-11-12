Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaKLB2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:28:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbaKLB2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 169/319] drm/radeon: fix speaker allocation setup
Date: Wed, 12 Nov 2014 10:15:07 +0900
Message-Id: <20141112011020.687402864@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4910403836ded89803fab201d4b5caaa85de3a89 upstream.

If the sad_count is 0, set the hw to stereo and change
the error message to a warn.  A lot of monitors don't
set the speaker allocation block.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/dce3_1_afmt.c    |    4 ++--
 drivers/gpu/drm/radeon/dce6_afmt.c      |    6 +++---
 drivers/gpu/drm/radeon/evergreen_hdmi.c |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -49,8 +49,8 @@ static void dce3_2_afmt_write_speaker_al
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector->edid, &sadb);
 	if (sad_count < 0) {
-		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
-		return;
+		DRM_DEBUG("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
+		sad_count = 0;
 	}
 
 	/* program the speaker allocation */
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -176,9 +176,9 @@ void dce6_afmt_write_speaker_allocation(
 	}
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector_edid(connector), &sadb);
-	if (sad_count <= 0) {
-		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
-		return;
+	if (sad_count < 0) {
+		DRM_DEBUG("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
+		sad_count = 0;
 	}
 
 	/* program the speaker allocation */
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -118,9 +118,9 @@ static void dce4_afmt_write_speaker_allo
 	}
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector_edid(connector), &sadb);
-	if (sad_count <= 0) {
-		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
-		return;
+	if (sad_count < 0) {
+		DRM_DEBUG("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
+		sad_count = 0;
 	}
 
 	/* program the speaker allocation */


