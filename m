Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbbA0MRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbbA0MRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 015/126] drm/radeon: fix sad_count check for dce3
Date: Tue, 27 Jan 2015 12:15:20 +0000
Message-Id: <1422361031-19364-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5665c3ebe5ee8a2c516925461f7214ba59c2e6d7 upstream.

Make it consistent with the sad code for other asics to deal
with monitors that don't report sads.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=89461

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/dce3_1_afmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c b/drivers/gpu/drm/radeon/dce3_1_afmt.c
index 13a27d971d35..9e2b5bfe4fa2 100644
--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -103,7 +103,7 @@ static void dce3_2_afmt_write_sad_regs(struct drm_encoder *encoder)
 	}
 
 	sad_count = drm_edid_to_sad(radeon_connector->edid, &sads);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
 		return;
 	}
-- 
2.1.4

