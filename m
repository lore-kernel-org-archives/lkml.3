Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaGEMoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:44:18 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59304 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaGEMoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:44:17 -0400
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
Subject: [PATCH] video: fbdev: riva: riva_hw.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:45:32 +0200
Message-Id: <1404564332-21450-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
 drivers/video/fbdev/riva/riva_hw.c |   50 ++++++++++--------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/video/fbdev/riva/riva_hw.c b/drivers/video/fbdev/riva/riva_hw.c
index 78fdbf5..f760749 100644
--- a/drivers/video/fbdev/riva/riva_hw.c
+++ b/drivers/video/fbdev/riva/riva_hw.c
@@ -247,14 +247,13 @@ static int nv3_iterate(nv3_fifo_info *res_info, nv3_sim_state * state, nv3_arb_i
     int mburst_size = 32;
     int mmisses, gmisses, vmisses;
     int misses;
-    int vlwm, glwm, mlwm;
+    int vlwm, glwm;
     int last, next, cur;
     int max_gfsize ;
     long ns;
 
     vlwm = 0;
     glwm = 0;
-    mlwm = 0;
     vfsize = 0;
     gfsize = 0;
     cur = ainfo->cur;
@@ -592,7 +591,7 @@ static void nv3CalcArbitration
         ainfo.gr_en = 1;
         ainfo.gdrain_rate = (int) state->pclk_khz * (state->pix_bpp/8);
         ainfo.vdrain_rate = 0;
-        res_gr = nv3_get_param(res_info, state,  &ainfo);
+        nv3_get_param(res_info, state,  &ainfo);
         res_gr = ainfo.converged;
         res_info->video_lwm = save_info.video_lwm;
         res_info->video_burst_size = save_info.video_burst_size;
@@ -602,7 +601,7 @@ static void nv3CalcArbitration
     {
         if (!ainfo.gr_en) ainfo.gdrain_rate = 0;
         if (!ainfo.vid_en) ainfo.vdrain_rate = 0;
-        res_gr = nv3_get_param(res_info, state,  &ainfo);
+        nv3_get_param(res_info, state,  &ainfo);
         res_info->valid = ainfo.converged;
     }
 }
@@ -657,13 +656,12 @@ static void nv4CalcArbitration
     nv4_sim_state *arb
 )
 {
-    int data, pagemiss, cas,width, video_enable, color_key_enable, bpp, align;
-    int nvclks, mclks, pclks, vpagemiss, crtpagemiss, vbs;
+    int data, pagemiss, cas, width, video_enable, bpp;
+    int nvclks, mclks, vpagemiss, crtpagemiss, vbs;
     int found, mclk_extra, mclk_loop, cbs, m1, p1;
     int mclk_freq, pclk_freq, nvclk_freq, mp_enable;
     int us_m, us_n, us_p, video_drain_rate, crtc_drain_rate;
     int vpm_us, us_video, vlwm, video_fill_us, cpm_us, us_crt,clwm;
-    int craw, vraw;
 
     fifo->valid = 1;
     pclk_freq = arb->pclk_khz;
@@ -673,14 +671,11 @@ static void nv4CalcArbitration
     cas = arb->mem_latency;
     width = arb->memory_width >> 6;
     video_enable = arb->enable_video;
-    color_key_enable = arb->gr_during_vid;
     bpp = arb->pix_bpp;
-    align = arb->mem_aligned;
     mp_enable = arb->enable_mp;
     clwm = 0;
     vlwm = 0;
     cbs = 128;
-    pclks = 2;
     nvclks = 2;
     nvclks += 2;
     nvclks += 1;
@@ -700,7 +695,6 @@ static void nv4CalcArbitration
     if (mp_enable)
         mclks+=4;
     nvclks += 0;
-    pclks += 0;
     found = 0;
     vbs = 0;
     while (found != 1)
@@ -783,8 +777,6 @@ static void nv4CalcArbitration
                 mclk_extra--;
             }
         }
-        craw = clwm;
-        vraw = vlwm;
         if (clwm < 384) clwm = 384;
         if (vlwm < 128) vlwm = 128;
         data = (int)(clwm);
@@ -843,17 +835,17 @@ static void nv10CalcArbitration
     nv10_sim_state *arb
 )
 {
-    int data, pagemiss, cas,width, video_enable, color_key_enable, bpp, align;
-    int nvclks, mclks, pclks, vpagemiss, crtpagemiss, vbs;
-    int nvclk_fill, us_extra;
+    int data, pagemiss, width, video_enable, bpp;
+    int nvclks, mclks, pclks, vpagemiss, crtpagemiss;
+    int nvclk_fill;
     int found, mclk_extra, mclk_loop, cbs, m1;
     int mclk_freq, pclk_freq, nvclk_freq, mp_enable;
-    int us_m, us_m_min, us_n, us_p, video_drain_rate, crtc_drain_rate;
-    int vus_m, vus_n, vus_p;
-    int vpm_us, us_video, vlwm, cpm_us, us_crt,clwm;
+    int us_m, us_m_min, us_n, us_p, crtc_drain_rate;
+    int vus_m;
+    int vpm_us, us_video, cpm_us, us_crt, clwm;
     int clwm_rnd_down;
-    int craw, m2us, us_pipe, us_pipe_min, vus_pipe, p1clk, p2;
-    int pclks_2_top_fifo, min_mclk_extra;
+    int m2us, us_pipe_min, p1clk, p2;
+    int min_mclk_extra;
     int us_min_mclk_extra;
 
     fifo->valid = 1;
@@ -861,18 +853,13 @@ static void nv10CalcArbitration
     mclk_freq = arb->mclk_khz;
     nvclk_freq = arb->nvclk_khz;
     pagemiss = arb->mem_page_miss;
-    cas = arb->mem_latency;
     width = arb->memory_width/64;
     video_enable = arb->enable_video;
-    color_key_enable = arb->gr_during_vid;
     bpp = arb->pix_bpp;
-    align = arb->mem_aligned;
     mp_enable = arb->enable_mp;
     clwm = 0;
-    vlwm = 1024;
 
     cbs = 512;
-    vbs = 512;
 
     pclks = 4; /* lwm detect. */
 
@@ -933,17 +920,11 @@ static void nv10CalcArbitration
       us_min_mclk_extra = min_mclk_extra *1000*1000 / mclk_freq;
       us_n = nvclks*1000*1000 / nvclk_freq;/* nvclk latency in us */
       us_p = pclks*1000*1000 / pclk_freq;/* nvclk latency in us */
-      us_pipe = us_m + us_n + us_p;
       us_pipe_min = us_m_min + us_n + us_p;
-      us_extra = 0;
 
       vus_m = mclk_loop *1000*1000 / mclk_freq; /* Mclk latency in us */
-      vus_n = (4)*1000*1000 / nvclk_freq;/* nvclk latency in us */
-      vus_p = 0*1000*1000 / pclk_freq;/* pclk latency in us */
-      vus_pipe = vus_m + vus_n + vus_p;
 
       if(video_enable) {
-        video_drain_rate = pclk_freq * 4; /* MB/s */
         crtc_drain_rate = pclk_freq * bpp/8; /* MB/s */
 
         vpagemiss = 1; /* self generating page miss */
@@ -1002,7 +983,6 @@ static void nv10CalcArbitration
               else if(crtc_drain_rate * 100  >= nvclk_fill * 98) {
                   clwm = 1024;
                   cbs = 512;
-                  us_extra = (cbs * 1000 * 1000)/ (8*width)/mclk_freq ;
               }
           }
       }
@@ -1019,7 +999,6 @@ static void nv10CalcArbitration
 
       m1 = clwm + cbs -  1024; /* Amount of overfill */
       m2us = us_pipe_min + us_min_mclk_extra;
-      pclks_2_top_fifo = (1024-clwm)/(8*width);
 
       /* pclk cycles to drain */
       p1clk = m2us * pclk_freq/(1000*1000); 
@@ -1047,7 +1026,6 @@ static void nv10CalcArbitration
               min_mclk_extra--;
         }
       }
-      craw = clwm;
 
       if(clwm < (1024-cbs+8)) clwm = 1024-cbs+8;
       data = (int)(clwm);
@@ -1863,7 +1841,7 @@ static void SetStartAddress3
     /*
      * 4 pixel pan register.
      */
-    offset = VGA_RD08(chip->PCIO, chip->IO + 0x0A);
+    VGA_RD08(chip->PCIO, chip->IO + 0x0A);
     VGA_WR08(chip->PCIO, 0x3C0, 0x13);
     VGA_WR08(chip->PCIO, 0x3C0, pan);
 }
-- 
1.7.10.4

