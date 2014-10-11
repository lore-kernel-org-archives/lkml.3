Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaJKMxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 08:53:10 -0400
Received: from wp038.webpack.hosteurope.de ([80.237.132.45]:46372 "EHLO
	wp038.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbaJKMxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 08:53:08 -0400
From: Henning Schild <henning@hennsch.de>
To: linux-kernel@vger.kernel.org
Cc: Henning Schild <henning@hennsch.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] drm/radeon: fix dangling pointer kfree
Date: Sat, 11 Oct 2014 14:37:47 +0200
Message-Id: <1413031067-26961-1-git-send-email-henning@hennsch.de>
X-Mailer: git-send-email 2.0.4
X-bounce-key: webpack.hosteurope.de;henning@hennsch.de;1413031988;90a67822;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If drm_edid_to_speaker_allocation returns a count of 0 sadb is not
initialized and should not get kfreed. Bail out like the other two
callers.

Signed-off-by: Henning Schild <henning@hennsch.de>
---
 drivers/gpu/drm/radeon/dce3_1_afmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c b/drivers/gpu/drm/radeon/dce3_1_afmt.c
index 51800e3..cb76074 100644
--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -48,7 +48,7 @@ static void dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	}
 
 	sad_count = drm_edid_to_speaker_allocation(radeon_connector->edid, &sadb);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read Speaker Allocation Data Block: %d\n", sad_count);
 		return;
 	}
-- 
2.0.4

