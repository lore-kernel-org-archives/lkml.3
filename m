Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaGFSww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:52:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53863 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaGFSwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:52:51 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: pvr2fb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:54:06 +0200
Message-Id: <1404672846-19986-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/pvr2fb.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 167cfff..da06b16 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -1075,7 +1075,6 @@ static struct pvr2_board {
 static int __init pvr2fb_init(void)
 {
 	int i, ret = -ENODEV;
-	int size;
 
 #ifndef MODULE
 	char *option = NULL;
@@ -1084,7 +1083,6 @@ static int __init pvr2fb_init(void)
 		return -ENODEV;
 	pvr2fb_setup(option);
 #endif
-	size = sizeof(struct fb_info) + sizeof(struct pvr2fb_par) + 16 * sizeof(u32);
 
 	fb_info = framebuffer_alloc(sizeof(struct pvr2fb_par), NULL);
 
-- 
1.7.10.4

