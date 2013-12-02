Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3LBTth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:49:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3LBTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Samuel Li <samuel.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 138/212] drm/radeon: hook up backlight functions for CI and KV family.
Date: Mon,  2 Dec 2013 11:15:29 -0800
Message-Id: <20131202191302.479163676@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Li <samuel.li@amd.com>

commit 7272c9d2286525d4c6bce788243cf2b6f306d15c upstream.

Fixes crashes when handling atif events due to the lack of a
callback being registered.

Signed-off-by: Samuel Li <samuel.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_asic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -2019,6 +2019,8 @@ static struct radeon_asic ci_asic = {
 		.bandwidth_update = &dce8_bandwidth_update,
 		.get_vblank_counter = &evergreen_get_vblank_counter,
 		.wait_for_vblank = &dce4_wait_for_vblank,
+		.set_backlight_level = &atombios_set_backlight_level,
+		.get_backlight_level = &atombios_get_backlight_level,
 		.hdmi_enable = &evergreen_hdmi_enable,
 		.hdmi_setmode = &evergreen_hdmi_setmode,
 	},
@@ -2119,6 +2121,8 @@ static struct radeon_asic kv_asic = {
 		.bandwidth_update = &dce8_bandwidth_update,
 		.get_vblank_counter = &evergreen_get_vblank_counter,
 		.wait_for_vblank = &dce4_wait_for_vblank,
+		.set_backlight_level = &atombios_set_backlight_level,
+		.get_backlight_level = &atombios_get_backlight_level,
 		.hdmi_enable = &evergreen_hdmi_enable,
 		.hdmi_setmode = &evergreen_hdmi_setmode,
 	},


