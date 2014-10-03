Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbaJDALY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:11:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaJCVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 022/238] drm/radeon/TN: only enable bapm on MSI systems
Date: Fri,  3 Oct 2014 14:28:57 -0700
Message-Id: <20141003212914.376268919@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 730a336c33a3398d65896e8ee3ef9f5679fe30a9 upstream.

There still seem to be stability problems with other systems.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=72921

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/trinity_dpm.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1877,15 +1877,16 @@ int trinity_dpm_init(struct radeon_devic
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++)
 		pi->at[i] = TRINITY_AT_DFLT;
 
-	/* There are stability issues reported on latops with
-	 * bapm installed when switching between AC and battery
-	 * power.  At the same time, some desktop boards hang
-	 * if it's not enabled and dpm is enabled.
+	/* There are stability issues reported on with
+	 * bapm enabled when switching between AC and battery
+	 * power.  At the same time, some MSI boards hang
+	 * if it's not enabled and dpm is enabled.  Just enable
+	 * it for MSI boards right now.
 	 */
-	if (rdev->flags & RADEON_IS_MOBILITY)
-		pi->enable_bapm = false;
-	else
+	if (rdev->pdev->subsystem_vendor == 0x1462)
 		pi->enable_bapm = true;
+	else
+		pi->enable_bapm = false;
 	pi->enable_nbps_policy = true;
 	pi->enable_sclk_ds = true;
 	pi->enable_gfx_power_gating = true;


