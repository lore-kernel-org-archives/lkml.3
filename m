Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab3BSSvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038Ab3BSSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 22/81] drm/radeon/evergreen+: wait for the MC to settle after MC blackout
Date: Tue, 19 Feb 2013 15:48:45 -0300
Message-Id: <1361299784-8830-23-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ed39fadd6df01095378e499fac3674883f16b853 upstream.

Some chips seem to need a little delay after blacking out
the MC before the requests actually stop.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=56139
https://bugs.freedesktop.org/show_bug.cgi?id=57567

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 4170e1e..ccac010 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1183,6 +1183,8 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 		blackout &= ~BLACKOUT_MODE_MASK;
 		WREG32(MC_SHARED_BLACKOUT_CNTL, blackout | 1);
 	}
+	/* wait for the MC to settle */
+	udelay(100);
 }
 
 void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save)
-- 
1.7.9.5

