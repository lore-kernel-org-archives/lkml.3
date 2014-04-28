Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaD1BcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42854 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Christian =?UTF-8?Q?K=C3=B6nig?=" <christian.koenig@amd.com>,
        "Alex Deucher" <alexander.deucher@amd.com>,
        "Alex Deucher" <alexdeucher@gmail.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.123523339@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 74/94] drm/radeon: call drm_edid_to_eld when we update
 the edid
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 16086279353cbfecbb3ead474072dced17b97ddc upstream.

This needs to be done to update some of the fields in
the connector structure used by the audio code.

Noticed by several users on irc.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_display.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -738,6 +738,7 @@ int radeon_ddc_get_modes(struct radeon_c
 	if (radeon_connector->edid) {
 		drm_mode_connector_update_edid_property(&radeon_connector->base, radeon_connector->edid);
 		ret = drm_add_edid_modes(&radeon_connector->base, radeon_connector->edid);
+		drm_edid_to_eld(&radeon_connector->base, radeon_connector->edid);
 		return ret;
 	}
 	drm_mode_connector_update_edid_property(&radeon_connector->base, NULL);

