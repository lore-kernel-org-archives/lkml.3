Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3HBKmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:42:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab3HBKLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 66/99] drm/radeon/hdmi: make sure we have an afmt block assigned
Date: Fri,  2 Aug 2013 18:08:19 +0800
Message-Id: <20130802100235.232203856@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c2b4cacfe9816c1fe378c785ce8a678cf0635ec6 upstream.

Prevents a segfault if an afmt block is not assigned to the
encoder such as in the LVDS or eDP case.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=66714

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_hdmi.c |    6 ++++++
 drivers/gpu/drm/radeon/r600_hdmi.c      |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -177,6 +177,9 @@ void evergreen_hdmi_setmode(struct drm_e
 	uint32_t offset;
 	ssize_t err;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (!dig->afmt->enabled)
 		return;
@@ -280,6 +283,9 @@ void evergreen_hdmi_enable(struct drm_en
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (enable && dig->afmt->enabled)
 		return;
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -266,6 +266,9 @@ void r600_hdmi_setmode(struct drm_encode
 	uint32_t offset;
 	ssize_t err;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (!dig->afmt->enabled)
 		return;
@@ -448,6 +451,9 @@ void r600_hdmi_enable(struct drm_encoder
 	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	u32 hdmi = HDMI0_ERROR_ACK;
 
+	if (!dig || !dig->afmt)
+		return;
+
 	/* Silent, r600_hdmi_enable will raise WARN for us */
 	if (enable && dig->afmt->enabled)
 		return;


