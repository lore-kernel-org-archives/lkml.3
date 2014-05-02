Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaEBPqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:46:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44357 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaEBPqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 122/151] drm/radeon: call drm_edid_to_eld when we update the edid
Date: Fri,  2 May 2014 08:38:30 -0700
Message-Id: <1399045139-4531-123-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 16086279353cbfecbb3ead474072dced17b97ddc upstream.

This needs to be done to update some of the fields in
the connector structure used by the audio code.

Noticed by several users on irc.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 7b25381..0ec48ea 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -790,6 +790,7 @@ int radeon_ddc_get_modes(struct radeon_connector *radeon_connector)
 	if (radeon_connector->edid) {
 		drm_mode_connector_update_edid_property(&radeon_connector->base, radeon_connector->edid);
 		ret = drm_add_edid_modes(&radeon_connector->base, radeon_connector->edid);
+		drm_edid_to_eld(&radeon_connector->base, radeon_connector->edid);
 		return ret;
 	}
 	drm_mode_connector_update_edid_property(&radeon_connector->base, NULL);
-- 
1.9.1

