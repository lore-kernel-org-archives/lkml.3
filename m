Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3AJUmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:42:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38535 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3AJUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:42:32 -0500
From: Paolo Pisati <paolo.pisati@canonical.com>
To: Rob Clark <rob@ti.com>
Cc: linux-omap@vger.kernel.org, Sumit Semwal <sumit.semwal@ti.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging/omapdrm: garbage collect OMAP_DSS_DISPLAY_SUSPENDED
Date: Thu, 10 Jan 2013 21:42:27 +0100
Message-Id: <1357850547-32270-1-git-send-email-paolo.pisati@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation fix - leftover from:

commit 998c336d4c7183301ed6a6ca93952f63e3cf694f
Author: Tomi Valkeinen <tomi.valkeinen@ti.com>
Date:   Wed May 30 13:26:00 2012 +0300

    OMAPDSS: remove omap_dss_device's suspend/resume

Cc: stable <stable@vger.kernel.org> # v3.7
Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 drivers/staging/omapdrm/omap_connector.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_connector.c b/drivers/staging/omapdrm/omap_connector.c
index 91edb3f..ff25467 100644
--- a/drivers/staging/omapdrm/omap_connector.c
+++ b/drivers/staging/omapdrm/omap_connector.c
@@ -113,9 +113,6 @@ static void omap_connector_dpms(struct drm_connector *connector, int mode)
 	if (mode == DRM_MODE_DPMS_ON) {
 		/* store resume info for suspended displays */
 		switch (dssdev->state) {
-		case OMAP_DSS_DISPLAY_SUSPENDED:
-			dssdev->activate_after_resume = true;
-			break;
 		case OMAP_DSS_DISPLAY_DISABLED: {
 			int ret = dssdev->driver->enable(dssdev);
 			if (ret) {
-- 
1.7.9.5

