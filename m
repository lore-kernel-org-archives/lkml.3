Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162605Ab3LFN2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:28:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44448 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161819Ab3LFNDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 189/272] drm/radeon: re-enable sw ACR support on pre-DCE4
Date: Fri,  6 Dec 2013 12:57:58 +0000
Message-Id: <1386334761-25517-190-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b852c985010a77c850b7548d64bbb964ca462b02 upstream.

HW ACR support may have issues on some older chips, so
use SW ACR for now until we've tested further.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
CC: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index ffd02da..4140fe8 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -345,6 +345,7 @@ void r600_hdmi_setmode(struct drm_encoder *encoder, struct drm_display_mode *mod
 	}
 
 	WREG32(HDMI0_ACR_PACKET_CONTROL + offset,
+	       HDMI0_ACR_SOURCE | /* select SW CTS value - XXX verify that hw CTS works on all families */
 	       HDMI0_ACR_AUTO_SEND); /* allow hw to sent ACR packets when required */
 
 	WREG32(HDMI0_VBI_PACKET_CONTROL + offset,
-- 
1.8.3.2

