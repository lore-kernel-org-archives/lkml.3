Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbaGEMg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:36:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47817 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaGEMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:36:28 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: omap: hwa742.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:37:42 +0200
Message-Id: <1404563862-20852-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/omap/hwa742.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap/hwa742.c b/drivers/video/fbdev/omap/hwa742.c
index a4ee65b..65b2370 100644
--- a/drivers/video/fbdev/omap/hwa742.c
+++ b/drivers/video/fbdev/omap/hwa742.c
@@ -787,7 +787,7 @@ static void calc_hwa742_clk_rates(unsigned long ext_clk,
 
 static int setup_tearsync(unsigned long pix_clk, int extif_div)
 {
-	int hdisp, vdisp;
+	int hdisp;
 	int hndp, vndp;
 	int hsw, vsw;
 	int hs, vs;
@@ -803,7 +803,7 @@ static int setup_tearsync(unsigned long pix_clk, int extif_div)
 	vsw = vsw & 0x3f;
 
 	hdisp = (hwa742_read_reg(HWA742_H_DISP_REG) & 0x7f) * 8;
-	vdisp = hwa742_read_reg(HWA742_V_DISP_1_REG) +
+	hwa742_read_reg(HWA742_V_DISP_1_REG) +
 		((hwa742_read_reg(HWA742_V_DISP_2_REG) & 0x3) << 8);
 
 	hndp = hwa742_read_reg(HWA742_H_NDP_REG) & 0x7f;
-- 
1.7.10.4

