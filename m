Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaGBWH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:07:28 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45258 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaGBWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:07:23 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: init301.c:  Cleaning up a potential division by zero
Date: Thu,  3 Jul 2014 00:08:35 +0200
Message-Id: <1404338915-6946-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404338915-6946-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404338915-6946-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up a potential division by zero.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/sis/init301.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sis/init301.c b/drivers/video/fbdev/sis/init301.c
index a89e3ca..730be06 100644
--- a/drivers/video/fbdev/sis/init301.c
+++ b/drivers/video/fbdev/sis/init301.c
@@ -5351,7 +5351,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 {
   unsigned short modeflag, resinfo = 0;
   unsigned short push2, tempax, tempbx, tempcx, temp;
-  unsigned int   tempeax = 0, tempebx, tempecx, tempvcfact = 0;
+  unsigned int   tempeax = 0, tempebx, tempecx, tempvcfact = 1;
   bool islvds = false, issis  = false, chkdclkfirst = false;
 #ifdef CONFIG_FB_SIS_300
   unsigned short crt2crtc = 0;
-- 
1.7.10.4

