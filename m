Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab3LFOTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:19:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120Ab3LFNAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Samuel Li <samuel.li@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 025/272] drm/radeon: hook up backlight functions for CI and KV family.
Date: Fri,  6 Dec 2013 12:55:14 +0000
Message-Id: <1386334761-25517-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Li <samuel.li@amd.com>

commit 7272c9d2286525d4c6bce788243cf2b6f306d15c upstream.

Fixes crashes when handling atif events due to the lack of a
callback being registered.

Signed-off-by: Samuel Li <samuel.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_asic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_asic.c b/drivers/gpu/drm/radeon/radeon_asic.c
index 8e5438e..1000a70 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -2423,6 +2423,8 @@ static struct radeon_asic ci_asic = {
 		.bandwidth_update = &dce8_bandwidth_update,
 		.get_vblank_counter = &evergreen_get_vblank_counter,
 		.wait_for_vblank = &dce4_wait_for_vblank,
+		.set_backlight_level = &atombios_set_backlight_level,
+		.get_backlight_level = &atombios_get_backlight_level,
 	},
 	.copy = {
 		.blit = NULL,
@@ -2578,6 +2580,8 @@ static struct radeon_asic kv_asic = {
 		.bandwidth_update = &dce8_bandwidth_update,
 		.get_vblank_counter = &evergreen_get_vblank_counter,
 		.wait_for_vblank = &dce4_wait_for_vblank,
+		.set_backlight_level = &atombios_set_backlight_level,
+		.get_backlight_level = &atombios_get_backlight_level,
 	},
 	.copy = {
 		.blit = NULL,
-- 
1.8.3.2

