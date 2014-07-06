Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaGFSZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:25:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44025 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaGFSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:25:42 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] video: fbdev: aty: radeon_base.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:26:57 +0200
Message-Id: <1404671217-17772-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/aty/radeon_base.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/aty/radeon_base.c b/drivers/video/fbdev/aty/radeon_base.c
index 26d80a4..aee65ba 100644
--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -1532,14 +1532,14 @@ static int radeonfb_set_par(struct fb_info *info)
 	struct fb_var_screeninfo *mode = &info->var;
 	struct radeon_regs *newmode;
 	int hTotal, vTotal, hSyncStart, hSyncEnd,
-	    hSyncPol, vSyncStart, vSyncEnd, vSyncPol, cSync;
+	    vSyncStart, vSyncEnd;
 	u8 hsync_adj_tab[] = {0, 0x12, 9, 9, 6, 5};
 	u8 hsync_fudge_fp[] = {2, 2, 0, 0, 5, 5};
 	u32 sync, h_sync_pol, v_sync_pol, dotClock, pixClock;
 	int i, freq;
 	int format = 0;
 	int nopllcalc = 0;
-	int hsync_start, hsync_fudge, bytpp, hsync_wid, vsync_wid;
+	int hsync_start, hsync_fudge, hsync_wid, vsync_wid;
 	int primary_mon = PRIMARY_MONITOR(rinfo);
 	int depth = var_to_depth(mode);
 	int use_rmx = 0;
@@ -1612,13 +1612,7 @@ static int radeonfb_set_par(struct fb_info *info)
 	else if (vsync_wid > 0x1f)	/* max */
 		vsync_wid = 0x1f;
 
-	hSyncPol = mode->sync & FB_SYNC_HOR_HIGH_ACT ? 0 : 1;
-	vSyncPol = mode->sync & FB_SYNC_VERT_HIGH_ACT ? 0 : 1;
-
-	cSync = mode->sync & FB_SYNC_COMP_HIGH_ACT ? (1 << 4) : 0;
-
 	format = radeon_get_dstbpp(depth);
-	bytpp = mode->bits_per_pixel >> 3;
 
 	if ((primary_mon == MT_DFP) || (primary_mon == MT_LCD))
 		hsync_fudge = hsync_fudge_fp[format-1];
-- 
1.7.10.4

