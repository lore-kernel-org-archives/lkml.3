Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaGFRc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:32:56 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38847 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaGFRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:32:54 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: omap: omapfb_main.c:  Cleaning up wrong type in format string
Date: Sun,  6 Jul 2014 19:34:09 +0200
Message-Id: <1404668049-15016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong type in sscanf format string, requires 'int *' but the
argument type is 'unsigned int *'

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/omap/omapfb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c
index d8d028d..7df0764 100644
--- a/drivers/video/fbdev/omap/omapfb_main.c
+++ b/drivers/video/fbdev/omap/omapfb_main.c
@@ -1371,7 +1371,7 @@ static ssize_t omapfb_store_bklight_level(struct device *dev,
 	if (fbdev->panel->set_bklight_level) {
 		unsigned int level;
 
-		if (sscanf(buf, "%10d", &level) == 1) {
+		if (sscanf(buf, "%10u", &level) == 1) {
 			r = fbdev->panel->set_bklight_level(fbdev->panel,
 							    level);
 		} else
-- 
1.7.10.4

