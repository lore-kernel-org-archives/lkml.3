Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaAMQCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaAMQCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/208] drm/radeon: check for 0 count in speaker allocation and SAD code
Date: Mon, 13 Jan 2014 15:58:20 +0000
Message-Id: <1389628849-1614-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b67ce39a30976171e7b96b30a94a0216ab89df97 upstream.

If there is no speaker allocation block or SAD block, bail
early.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=72283

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.11:
  - applied changes to evergreen_hdmi_write_sad_regs() function only ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index 869b4d6..7a0e347 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -88,7 +88,7 @@ static void evergreen_hdmi_write_sad_regs(struct drm_encoder *encoder)
 	}
 
 	sad_count = drm_edid_to_sad(radeon_connector->edid, &sads);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
 		return;
 	}
-- 
1.8.3.2

