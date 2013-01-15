Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3APAJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:09:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:43029 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364Ab3AOWdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 149/221] radeon/kms: force rn50 chip to always report connected on analog output
Date: Tue, 15 Jan 2013 10:51:16 -0800
Message-Id: <20130115185008.805892956@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 51861d4eebc2ddc25c77084343d060fa79f6e291 upstream.

Those rn50 chip are often connected to console remoting hw and load
detection often fails with those. Just don't try to load detect and
report connect.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -640,6 +640,14 @@ static enum drm_connector_status radeon_
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


