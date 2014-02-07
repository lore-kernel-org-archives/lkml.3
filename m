Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaBGMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:25:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaBGLvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 151/233] drm/radeon/dpm: disable mclk switching on desktop RV770
Date: Fri,  7 Feb 2014 11:46:10 +0000
Message-Id: <1391773652-25214-152-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8097d94116d0c17e774ba4c8256e774018dc2a46 upstream.

Mclk switching doesn't seem to work reliably on these
cards.  Most RV770 boards specify the same mclk for all
performance levels anyway so in most cases, this has
no affect.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73067

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/rv770_dpm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index 4f17b31..a923ba9 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2536,6 +2536,12 @@ bool rv770_dpm_vblank_too_short(struct radeon_device *rdev)
 	    (rdev->pdev->subsystem_device == 0x1c42))
 		switch_limit = 200;
 
+	/* RV770 */
+	/* mclk switching doesn't seem to work reliably on desktop RV770s */
+	if ((rdev->family == CHIP_RV770) &&
+	    !(rdev->flags & RADEON_IS_MOBILITY))
+		switch_limit = 0xffffffff; /* disable mclk switching */
+
 	if (vblank_time < switch_limit)
 		return true;
 	else
-- 
1.8.3.2

