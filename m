Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3CNKoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:44:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52048 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab3CNKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 70/88] drm/radeon: add primary dac adj quirk for R200 board
Date: Thu, 14 Mar 2013 10:36:03 +0000
Message-Id: <1363257381-15900-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e8fc41377f5037ff7a661ea06adc05f1daec1548 upstream.

vbios values are wrong leading to colors that are
too bright.  Use the default values instead.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 7139341..77c50cc 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -958,6 +958,15 @@ struct radeon_encoder_primary_dac *radeon_combios_get_primary_dac_info(struct
 			found = 1;
 	}
 
+	/* quirks */
+	/* Radeon 9100 (R200) */
+	if ((dev->pdev->device == 0x514D) &&
+	    (dev->pdev->subsystem_vendor == 0x174B) &&
+	    (dev->pdev->subsystem_device == 0x7149)) {
+		/* vbios value is bad, use the default */
+		found = 0;
+	}
+
 	if (!found) /* fallback to defaults */
 		radeon_legacy_get_primary_dac_info_from_table(rdev, p_dac);
 
-- 
1.8.1.2

