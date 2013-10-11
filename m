Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3JKIBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab3JKIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:01:34 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/6] drm/cirrus: use drm_set_preferred_mode
Date: Fri, 11 Oct 2013 10:01:09 +0200
Message-Id: <1381478473-18159-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
References: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly set 1024x768 as default mode, so the display doesn't come up
with the largest supported mode.

While being at it drop first three drm_add_modes_noedid calls.  As
drm_add_modes_noedid fills the mode list with modes from the database
*up to* the specified size it is pretty pointless to call it multiple
times with different sizes.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/cirrus/cirrus_mode.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index 60685b2..adabc3d 100644
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
1.8.3.1

