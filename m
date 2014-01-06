Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaAGAAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:00:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbaAFWjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 072/144] drm/radeon: check for 0 count in speaker allocation and SAD code
Date: Mon,  6 Jan 2014 14:37:13 -0800
Message-Id: <20140106223747.412278346@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b67ce39a30976171e7b96b30a94a0216ab89df97 upstream.

If there is no speaker allocation block or SAD block, bail
early.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=72283

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/dce6_afmt.c      |    4 ++--
 drivers/gpu/drm/radeon/evergreen_hdmi.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -132,7 +132,7 @@ void dce6_afmt_write_speaker_allocation(
 	}
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector->edid, &sadb);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
 		return;
 	}
@@ -193,7 +193,7 @@ void dce6_afmt_write_sad_regs(struct drm
 	}
 
 	sad_count = drm_edid_to_sad(radeon_connector->edid, &sads);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
 		return;
 	}
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -81,7 +81,7 @@ static void dce4_afmt_write_speaker_allo
 	}
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector->edid, &sadb);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
 		return;
 	}
@@ -134,7 +134,7 @@ static void evergreen_hdmi_write_sad_reg
 	}
 
 	sad_count = drm_edid_to_sad(radeon_connector->edid, &sads);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
 		return;
 	}


