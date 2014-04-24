Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbaDXMmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:42:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51073 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193AbaDXMhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:37:01 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 06/13] video: export fb_prepare_logo
Date: Thu, 24 Apr 2014 13:28:22 +0100
Message-Id: <1398342509-10243-7-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Some drivers that may be loadable modules use the fb_prepare_logo
function, so we have to export it. Found during randconfig
builds with mmpfb.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/fbdev/core/fbmem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index b6d5008..479fe2a 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -674,6 +674,7 @@ int fb_show_logo(struct fb_info *info, int rotate)
 int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }
 int fb_show_logo(struct fb_info *info, int rotate) { return 0; }
 #endif /* CONFIG_LOGO */
+EXPORT_SYMBOL(fb_prepare_logo);
 EXPORT_SYMBOL(fb_show_logo);
 
 static void *fb_seq_start(struct seq_file *m, loff_t *pos)
-- 
1.7.9.5

