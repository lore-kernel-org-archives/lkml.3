Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967019Ab3DRJWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:22:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200Ab3DRJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 59/72] udl: handle EDID failure properly.
Date: Thu, 18 Apr 2013 10:16:44 +0100
Message-Id: <1366276617-3553-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@gmail.com>

commit 1baee58638fc58248625255f5c5fcdb987f11b1f upstream.

Don't oops seems proper.

Signed-off-by: Dave Airlie <airlied@redhat.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/udl/udl_connector.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index 3234224..b8e6463 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -61,6 +61,10 @@ static int udl_get_modes(struct drm_connector *connector)
 	int ret;
 
 	edid = (struct edid *)udl_get_edid(udl);
+	if (!edid) {
+		drm_mode_connector_update_edid_property(connector, NULL);
+		return 0;
+	}
 
 	connector->display_info.raw_edid = (char *)edid;
 
-- 
1.8.1.2

