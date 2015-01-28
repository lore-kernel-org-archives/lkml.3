Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbbA2JSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:18:48 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44908 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753863AbbA2JHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/176] drm/radeon: fix typo in CI dpm disable
Date: Wed, 28 Jan 2015 15:28:23 +0100
Message-Id: <2ae5f6c0b469c5eb92716f583b8d10f76f68a0b8.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 129acb7c0b682512e89c4f65c33593d50f2f49a9 upstream.

Need to disable DS, not enable it when disabling dpm.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 95f4ab99c44b..0a8fc92f6eab 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4698,7 +4698,7 @@ void ci_dpm_disable(struct radeon_device *rdev)
 	ci_enable_spread_spectrum(rdev, false);
 	ci_enable_auto_throttle_source(rdev, RADEON_DPM_AUTO_THROTTLE_SRC_THERMAL, false);
 	ci_stop_dpm(rdev);
-	ci_enable_ds_master_switch(rdev, true);
+	ci_enable_ds_master_switch(rdev, false);
 	ci_enable_ulv(rdev, false);
 	ci_clear_vc(rdev);
 	ci_reset_to_default(rdev);
-- 
2.2.2

