Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaGFRfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:35:17 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:52123 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaGFRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:35:15 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: sis_main.c:  Cleaning up wrong type in format string
Date: Sun,  6 Jul 2014 19:36:30 +0200
Message-Id: <1404668190-15199-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong type in printf format string, requires 'unsigned int'
but the argument type is 'int'

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/sis/sis_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 22ad028..ab7e5e4 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -237,7 +237,7 @@ static void sisfb_get_vga_mode_from_kernel(void)
 
 		if(mydepth == 24) mydepth = 32;
 
-		sprintf(mymode, "%ux%ux%u", screen_info.lfb_width,
+		sprintf(mymode, "%ux%ux%d", screen_info.lfb_width,
 					screen_info.lfb_height,
 					mydepth);
 
-- 
1.7.10.4

