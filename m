Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaLCL1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaLCL1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 036/101] drm/radeon: add missing crtc unlock when setting up the MC
Date: Wed,  3 Dec 2014 12:25:58 +0100
Message-Id: <984e580d41b0e91b37e53f64f2455618c49e571b.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f0d7bfb9407fccb6499ec01c33afe43512a439a2 upstream.

Need to unlock the crtc after updating the blanking state.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/evergreen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 9e726f2d2e75..20b00a0f42b4 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2523,6 +2523,7 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
-- 
2.1.3

