Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3BCPVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:21:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34171 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814Ab3BCOzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:20 -0500
Message-Id: <20130203144646.884841790@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 032/128] radeon/kms: force rn50 chip to always report connected on analog
 output
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 51861d4eebc2ddc25c77084343d060fa79f6e291 upstream.

Those rn50 chip are often connected to console remoting hw and load
detection often fails with those. Just don't try to load detect and
report connect.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index f5ba224..62cd512 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -640,6 +640,14 @@ static enum drm_connector_status radeon_legacy_primary_dac_detect(struct drm_enc
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


