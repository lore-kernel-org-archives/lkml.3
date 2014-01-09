Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaAIShs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:37:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44238 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaAIShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:37:41 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] drm/panel: update EDID BLOB in panel_simple_get_modes()
Date: Thu,  9 Jan 2014 11:37:34 -0700
Message-Id: <1389292654-20491-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This stashes away the EDID data so that the sysfs per-connector file
"edid" can display it. Without this change, the "edid" file is always
empty.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 520b569ae3c8..59d52ca2c67f 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -162,6 +162,7 @@ static int panel_simple_get_modes(struct drm_panel *panel)
 	/* probe EDID if a DDC bus is available */
 	if (p->ddc) {
 		struct edid *edid = drm_get_edid(panel->connector, p->ddc);
+		drm_mode_connector_update_edid_property(panel->connector, edid);
 		if (edid) {
 			num += drm_add_edid_modes(panel->connector, edid);
 			kfree(edid);
-- 
1.8.1.5

