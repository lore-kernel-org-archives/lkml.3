Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaFOVva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:51:30 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:40830 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaFOVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:51:15 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: init301.c:  Cleaning up useless if statement
Date: Sun, 15 Jun 2014 23:52:10 +0200
Message-Id: <1402869130-4962-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402869130-4962-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402869130-4962-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code is run regardless of the outcome of the if statement.
And sets a variable that is missed, a probable cut and paste mistake.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/sis/init301.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/video/fbdev/sis/init301.c b/drivers/video/fbdev/sis/init301.c
index a89e3ca..008ab4a 100644
--- a/drivers/video/fbdev/sis/init301.c
+++ b/drivers/video/fbdev/sis/init301.c
@@ -1714,7 +1714,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
 			       SiS_Pr->PanelVCLKIdx315 = VCLK81_315; /* ? */
 			    } else {
 			       SiS_Pr->PanelHT   = 1688; SiS_Pr->PanelVT   =  802;
-			       SiS_Pr->PanelHRS  =   48; SiS_Pr->PanelHRS  =  112;
+			       SiS_Pr->PanelHRS  =   48; SiS_Pr->PanelHRE  =  112;
 			       SiS_Pr->PanelVRS  =    3; SiS_Pr->PanelVRE  =    6;
 			       SiS_Pr->PanelVCLKIdx300 = VCLK81_300;
 			       SiS_Pr->PanelVCLKIdx315 = VCLK81_315;
@@ -6850,11 +6850,9 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 	   if(SiS_Pr->SiS_VGAHDE >= 1280) {
               tempch = 20;
               tempbx &= ~0x20;
-           } else if(SiS_Pr->SiS_VGAHDE >= 1024) {
-              tempch = 25;
            } else {
-	      tempch = 25; /* OK */
-	   }
+              tempch = 25; /* OK */
+          }
         }
      }
   }
@@ -7971,13 +7969,8 @@ SiS_SetCHTVReg(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
          }
       } else {						/* ---- PAL ---- */
          /* We don't play around with FSCI in PAL mode */
-         if(resindex == 0x04) {
-            SiS_SetCH70xxANDOR(SiS_Pr,0x20,0x00,0xEF);	/* loop filter off */
-            SiS_SetCH70xxANDOR(SiS_Pr,0x21,0x01,0xFE);	/* ACIV on */
-         } else {
-            SiS_SetCH70xxANDOR(SiS_Pr,0x20,0x00,0xEF);	/* loop filter off */
-            SiS_SetCH70xxANDOR(SiS_Pr,0x21,0x01,0xFE);	/* ACIV on */
-         }
+         SiS_SetCH70xxANDOR(SiS_Pr, 0x20, 0x00, 0xEF);	/* loop filter off */
+         SiS_SetCH70xxANDOR(SiS_Pr, 0x21, 0x01, 0xFE);	/* ACIV on */
       }
 
 #endif  /* 300 */
@@ -9663,8 +9656,6 @@ SetDelayComp(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 	      delay = 0x0a;
 	   } else if(IS_SIS740) {
 	      delay = 0x00;
-	   } else if(SiS_Pr->ChipType < SIS_330) {
-	      delay = 0x0c;
 	   } else {
 	      delay = 0x0c;
 	   }
-- 
1.7.10.4

