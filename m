Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaGFSmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:42:16 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:63570 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaGFSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:42:15 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>, Denis Carikli <denis@eukrea.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: mx3fb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:43:30 +0200
Message-Id: <1404672210-19147-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/mx3fb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/mx3fb.c b/drivers/video/fbdev/mx3fb.c
index c645a0a..ac38cb1 100644
--- a/drivers/video/fbdev/mx3fb.c
+++ b/drivers/video/fbdev/mx3fb.c
@@ -449,7 +449,6 @@ static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
 static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 {
 	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
-	uint32_t enabled;
 	unsigned long flags;
 
 	if (mx3_fbi->txd == NULL)
@@ -457,7 +456,7 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 
 	spin_lock_irqsave(&mx3fb->lock, flags);
 
-	enabled = sdc_fb_uninit(mx3_fbi);
+	sdc_fb_uninit(mx3_fbi);
 
 	spin_unlock_irqrestore(&mx3fb->lock, flags);
 
-- 
1.7.10.4

