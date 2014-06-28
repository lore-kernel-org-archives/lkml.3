Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaF1RxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:53:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaF1Rw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: [PATCH 3.15 108/139] Revert "drm/radeon: use variable UVD clocks"
Date: Sat, 28 Jun 2014 10:47:49 -0700
Message-Id: <20140628174610.347226627@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0690a229c69f40a6c9c459ab455c85df49822525 upstream.

This caused reduced performance for some users with advanced post
processing enabled.  We need a better method to pick the
UVD state based on the amount of post processing required or tune
the advanced post processing to fit within the lower power state
envelope.

This reverts commit 14a9579ddbf15dd1992a9481a4ec80b0b91656d5.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c  |    3 +++
 drivers/gpu/drm/radeon/radeon_uvd.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -984,6 +984,8 @@ void radeon_dpm_enable_uvd(struct radeon
 		if (enable) {
 			mutex_lock(&rdev->pm.mutex);
 			rdev->pm.dpm.uvd_active = true;
+			/* disable this for now */
+#if 0
 			if ((rdev->pm.dpm.sd == 1) && (rdev->pm.dpm.hd == 0))
 				dpm_state = POWER_STATE_TYPE_INTERNAL_UVD_SD;
 			else if ((rdev->pm.dpm.sd == 2) && (rdev->pm.dpm.hd == 0))
@@ -993,6 +995,7 @@ void radeon_dpm_enable_uvd(struct radeon
 			else if ((rdev->pm.dpm.sd == 0) && (rdev->pm.dpm.hd == 2))
 				dpm_state = POWER_STATE_TYPE_INTERNAL_UVD_HD2;
 			else
+#endif
 				dpm_state = POWER_STATE_TYPE_INTERNAL_UVD;
 			rdev->pm.dpm.state = dpm_state;
 			mutex_unlock(&rdev->pm.mutex);
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -812,7 +812,8 @@ void radeon_uvd_note_usage(struct radeon
 		    (rdev->pm.dpm.hd != hd)) {
 			rdev->pm.dpm.sd = sd;
 			rdev->pm.dpm.hd = hd;
-			streams_changed = true;
+			/* disable this for now */
+			/*streams_changed = true;*/
 		}
 	}
 


