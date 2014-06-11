Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaFKTzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:55:19 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:47097 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbaFKTzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:55:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugHAL6ymFNbslCP/2dsb2JhbABagw2rdAUBAQEBAQEFAZkbgQgXdYQxLyOBGjeIRgHQNxeFXIh9HYQrBJouiyqIIYF8gUI7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 1/1] drivers/video/fbdev/sis/sis_main.c: remove unnecessary test on unsigned value
Date: Wed, 11 Jun 2014 21:54:00 +0200
Message-Id: <1402516440-20554-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned value is never < 0

Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/video/fbdev/sis/sis_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 22ad028..3f12a2d 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -1572,10 +1572,6 @@ sisfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	/* Adapt RGB settings */
 	sisfb_bpp_to_var(ivideo, var);
 
-	/* Sanity check for offsets */
-	if(var->xoffset < 0) var->xoffset = 0;
-	if(var->yoffset < 0) var->yoffset = 0;
-
 	if(var->xres > var->xres_virtual)
 		var->xres_virtual = var->xres;
 
-- 
1.8.4.5

