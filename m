Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161833Ab3LFNDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161753Ab3LFNDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 188/272] drm/radeon: use hw generated CTS/N values for audio
Date: Fri,  6 Dec 2013 12:57:57 +0000
Message-Id: <1386334761-25517-189-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ee0fec312a1c4e26f255955da942562cd8908a4b upstream.

Use the hw generated values rather than calculating
them in the driver.  There may be some older r6xx
asics where this doesn't work correctly.  This remains
to be seen.

See bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69675

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 3 +--
 drivers/gpu/drm/radeon/r600_hdmi.c      | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index b0e2800..869b4d6 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -241,8 +241,7 @@ void evergreen_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode
 	/* fglrx clears sth in AFMT_AUDIO_PACKET_CONTROL2 here */
 
 	WREG32(HDMI_ACR_PACKET_CONTROL + offset,
-	       HDMI_ACR_AUTO_SEND | /* allow hw to sent ACR packets when required */
-	       HDMI_ACR_SOURCE); /* select SW CTS value */
+	       HDMI_ACR_AUTO_SEND); /* allow hw to sent ACR packets when required */
 
 	evergreen_hdmi_update_ACR(encoder, mode->clock);
 
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 7fafcab..ffd02da 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -345,8 +345,7 @@ void r600_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode *mod
 	}
 
 	WREG32(HDMI0_ACR_PACKET_CONTROL + offset,
-	       HDMI0_ACR_AUTO_SEND | /* allow hw to sent ACR packets when required */
-	       HDMI0_ACR_SOURCE); /* select SW CTS value */
+	       HDMI0_ACR_AUTO_SEND); /* allow hw to sent ACR packets when required */
 
 	WREG32(HDMI0_VBI_PACKET_CONTROL + offset,
 	       HDMI0_NULL_SEND | /* send null packets when required */
-- 
1.8.3.2

