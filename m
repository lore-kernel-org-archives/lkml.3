Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaGEMlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:41:14 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:50337 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaGEMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:41:13 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Archit Taneja <archit@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: omap2: dss: rfbi.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:42:29 +0200
Message-Id: <1404564149-21193-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
 drivers/video/fbdev/omap2/dss/rfbi.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/video/fbdev/omap2/dss/rfbi.c b/drivers/video/fbdev/omap2/dss/rfbi.c
index c8a81a2..6f03bbb 100644
--- a/drivers/video/fbdev/omap2/dss/rfbi.c
+++ b/drivers/video/fbdev/omap2/dss/rfbi.c
@@ -574,7 +574,6 @@ static int rfbi_setup_te(enum omap_rfbi_te_mode mode,
 {
 	int hs, vs;
 	int min;
-	u32 l;
 
 	hs = ps_to_rfbi_ticks(hs_pulse_time, 1);
 	vs = ps_to_rfbi_ticks(vs_pulse_time, 1);
@@ -595,15 +594,7 @@ static int rfbi_setup_te(enum omap_rfbi_te_mode mode,
 	rfbi_write_reg(RFBI_HSYNC_WIDTH, hs);
 	rfbi_write_reg(RFBI_VSYNC_WIDTH, vs);
 
-	l = rfbi_read_reg(RFBI_CONFIG(0));
-	if (hs_pol_inv)
-		l &= ~(1 << 21);
-	else
-		l |= 1 << 21;
-	if (vs_pol_inv)
-		l &= ~(1 << 20);
-	else
-		l |= 1 << 20;
+	rfbi_read_reg(RFBI_CONFIG(0));
 
 	return 0;
 }
-- 
1.7.10.4

