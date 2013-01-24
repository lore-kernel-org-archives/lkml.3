Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3AXDas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:30:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3AXDaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 40/74] radeon/kms: force rn50 chip to always report connected on analog output
Date: Thu, 24 Jan 2013 01:26:52 -0200
Message-Id: <1358998046-613-41-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 51861d4eebc2ddc25c77084343d060fa79f6e291 upstream.

Those rn50 chip are often connected to console remoting hw and load
detection often fails with those. Just don't try to load detect and
report connect.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index 8148cf8..e03f90e 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -618,6 +618,14 @@ static enum drm_connector_status radeon_legacy_primary_dac_detect(struct drm_enc
 	enum drm_connector_status found = connector_status_disconnected;
 	bool color = true;
 
+	/* just don't bother on RN50 those chip are often connected to remoting
+	 * console hw and often we get failure to load detect those. So to make
+	 * everyone happy report the encoder as always connected.
+	 */
+	if (ASIC_IS_RN50(rdev)) {
+		return connector_status_connected;
+	}
+
 	/* save the regs we need */
 	vclk_ecp_cntl = RREG32_PLL(RADEON_VCLK_ECP_CNTL);
 	crtc_ext_cntl = RREG32(RADEON_CRTC_EXT_CNTL);
-- 
1.7.9.5

