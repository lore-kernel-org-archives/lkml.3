Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaDRJYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:24:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45903 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 23/72] drm/cirrus: use drm_set_preferred_mode
Date: Fri, 18 Apr 2014 11:21:56 +0200
Message-Id: <7837b5ae7cd2a1be36cef09f923289fe7c076a34.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 121a6a17439b000b9699c3fa876636db20fa4107 upstream.

Explicitly set 1024x768 as default mode, so the display doesn't come up
with the largest supported mode.

While being at it drop first three drm_add_modes_noedid calls.  As
drm_add_modes_noedid fills the mode list with modes from the database
*up to* the specified size it is pretty pointless to call it multiple
times with different sizes.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/cirrus/cirrus_mode.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index 379a47ea99f6..3592616d484b 100644
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -494,13 +494,12 @@ static struct drm_encoder *cirrus_encoder_init(struct drm_device *dev)
 
 int cirrus_vga_get_modes(struct drm_connector *connector)
 {
-	/* Just add a static list of modes */
-	drm_add_modes_noedid(connector, 640, 480);
-	drm_add_modes_noedid(connector, 800, 600);
-	drm_add_modes_noedid(connector, 1024, 768);
-	drm_add_modes_noedid(connector, 1280, 1024);
+	int count;
 
-	return 4;
+	/* Just add a static list of modes */
+	count = drm_add_modes_noedid(connector, 1280, 1024);
+	drm_set_preferred_mode(connector, 1024, 768);
+	return count;
 }
 
 static int cirrus_vga_mode_valid(struct drm_connector *connector,
-- 
1.9.2

