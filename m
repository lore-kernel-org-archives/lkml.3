Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaKYKnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaKYKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 180/254] drm/radeon: add missing crtc unlock when setting up the MC
Date: Tue, 25 Nov 2014 10:38:50 +0000
Message-Id: <1416912004-5928-181-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f0d7bfb9407fccb6499ec01c33afe43512a439a2 upstream.

Need to unlock the crtc after updating the blanking state.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index cd620bca6dd6..d65a96562498 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2557,6 +2557,7 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
-- 
2.1.0

