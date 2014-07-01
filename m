Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbaGASw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:52:56 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:1352 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756772AbaGASwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:52:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0HABwDs1NbsGsk/2dsb2JhbABagw2sYwUBbpIbh0CBDRd1hAsCJC8jgQkRN4hGAbMClWAXhW+ITGQdhC0Fl3yCaotFiD6DRDuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1] drm/omap: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
Date: Tue,  1 Jul 2014 20:52:50 +0200
Message-Id: <1404240770-14938-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: David Airlie <airlied@linux.ie>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/omapdrm/omap_fbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_fbdev.c b/drivers/gpu/drm/omapdrm/omap_fbdev.c
index 1388ca7..8068612 100644
--- a/drivers/gpu/drm/omapdrm/omap_fbdev.c
+++ b/drivers/gpu/drm/omapdrm/omap_fbdev.c
@@ -169,7 +169,7 @@ static int omap_fbdev_create(struct drm_fb_helper *helper,
 	fbdev->ywrap_enabled = priv->has_dmm && ywrap_enabled;
 	if (fbdev->ywrap_enabled) {
 		/* need to align pitch to page size if using DMM scrolling */
-		mode_cmd.pitches[0] = ALIGN(mode_cmd.pitches[0], PAGE_SIZE);
+		mode_cmd.pitches[0] = PAGE_ALIGN(mode_cmd.pitches[0]);
 	}
 
 	/* allocate backing bo */
-- 
1.9.1

