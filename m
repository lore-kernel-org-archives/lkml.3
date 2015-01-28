Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbbA2BRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:17:15 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35115 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbA2BRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:17:13 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vitor Braga <vitorpybraga@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Thomas Gummerer <t.gummerer@gmail.com>,
        Brian Vandre <bvandre@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: xgifb: XGI_main_26: Change variables that is never used
Date: Wed, 28 Jan 2015 22:38:07 +0100
Message-Id: <1422481087-30938-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
Instead use the struct variable of the same name.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/xgifb/XGI_main_26.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 709d49e..ecfdf34 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1233,7 +1233,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	unsigned int vtotal = 0;
 	unsigned int drate = 0, hrate = 0;
 	int found_mode = 0;
-	int refresh_rate, search_idx;
+	int search_idx;
 
 	if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
 		vtotal = var->upper_margin + var->yres + var->lower_margin
@@ -1271,7 +1271,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	/* Calculation wrong for 1024x600 - force it to 60Hz */
 	if ((var->xres == 1024) && (var->yres == 600))
-		refresh_rate = 60;
+		xgifb_info->refresh_rate = 60;
 
 	search_idx = 0;
 	while ((XGIbios_mode[search_idx].mode_no != 0) &&
-- 
1.7.10.4

