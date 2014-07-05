Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaGEMec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:34:32 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35764 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaGEMea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:34:30 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: nvidia: nv_hw.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:35:46 +0200
Message-Id: <1404563746-20686-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
 drivers/video/fbdev/nvidia/nv_hw.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/nvidia/nv_hw.c b/drivers/video/fbdev/nvidia/nv_hw.c
index 81c80ac..031a3ac 100644
--- a/drivers/video/fbdev/nvidia/nv_hw.c
+++ b/drivers/video/fbdev/nvidia/nv_hw.c
@@ -242,7 +242,7 @@ static void nvGetClocks(struct nvidia_par *par, unsigned int *MClk,
 static void nv4CalcArbitration(nv4_fifo_info * fifo, nv4_sim_state * arb)
 {
 	int data, pagemiss, cas, width, video_enable, bpp;
-	int nvclks, mclks, pclks, vpagemiss, crtpagemiss, vbs;
+	int nvclks, mclks, vpagemiss, crtpagemiss, vbs;
 	int found, mclk_extra, mclk_loop, cbs, m1, p1;
 	int mclk_freq, pclk_freq, nvclk_freq, mp_enable;
 	int us_m, us_n, us_p, video_drain_rate, crtc_drain_rate;
@@ -261,7 +261,6 @@ static void nv4CalcArbitration(nv4_fifo_info * fifo, nv4_sim_state * arb)
 	clwm = 0;
 	vlwm = 0;
 	cbs = 128;
-	pclks = 2;
 	nvclks = 2;
 	nvclks += 2;
 	nvclks += 1;
@@ -281,7 +280,6 @@ static void nv4CalcArbitration(nv4_fifo_info * fifo, nv4_sim_state * arb)
 	if (mp_enable)
 		mclks += 4;
 	nvclks += 0;
-	pclks += 0;
 	found = 0;
 	vbs = 0;
 	while (found != 1) {
-- 
1.7.10.4

