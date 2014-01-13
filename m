Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaAMQCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaAMQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 058/208] drm/radeon/dpm: disable ss on Cayman
Date: Mon, 13 Jan 2014 15:58:19 +0000
Message-Id: <1389628849-1614-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c745fe611ca42295c9d91d8e305d27983e9132ef upstream.

Spread spectrum seems to cause hangs when dynamic clock
switching is enabled.  Disable it for now. This does not
affect performance or the amount of power saved. Tracked
down by Martin Andersson.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69723

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/rv770_dpm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index 4d50ca3..4f17b31 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2333,6 +2333,12 @@ void rv770_get_engine_memory_ss(struct radeon_device *rdev)
 	pi->mclk_ss = radeon_atombios_get_asic_ss_info(rdev, &ss,
 						       ASIC_INTERNAL_MEMORY_SS, 0);
 
+	/* disable ss, causes hangs on some cayman boards */
+	if (rdev->family == CHIP_CAYMAN) {
+		pi->sclk_ss = false;
+		pi->mclk_ss = false;
+	}
+
 	if (pi->sclk_ss || pi->mclk_ss)
 		pi->dynamic_ss = true;
 	else
-- 
1.8.3.2

