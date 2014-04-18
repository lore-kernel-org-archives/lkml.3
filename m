Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaDRJXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:23:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45911 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 17/72] drm/radeon: enable speaker allocation setup on dce3.2
Date: Fri, 18 Apr 2014 11:21:50 +0200
Message-Id: <21a4209d4288e5075edcd46881fd4b78a5a9bf3d.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3803c8e5b50946dd6bc18972d9190757d05648f0 upstream.

Now that we disable audio while setting up the audio
hw, we should be able to set this up without hangs.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/r600_hdmi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 9ba0675d0682..d38b725563e4 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -329,9 +329,6 @@ static void dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	u8 *sadb;
 	int sad_count;
 
-	/* XXX: setting this register causes hangs on some asics */
-	return;
-
 	list_for_each_entry(connector, &encoder->dev->mode_config.connector_list, head) {
 		if (connector->encoder == encoder)
 			radeon_connector = to_radeon_connector(connector);
-- 
1.9.2

