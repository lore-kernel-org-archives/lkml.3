Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaF3L6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:58:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52112 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhichuang SUN <sunzc522@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-fbdev@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/181] drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap
Date: Mon, 30 Jun 2014 13:51:07 +0200
Message-Id: <e4b1dada19b4fc97ca2aafd952c7edebf3276a1f.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhichuang SUN <sunzc522@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fbc6c4a13bbfb420eedfdb26a0a859f9c07e8a7b upstream.

Function unifb_mmap calls functions which are defined in linux/mm.h
and asm/pgtable.h

The related error (for unicore32 with unicore32_defconfig):
	CC      drivers/video/fbdev/fb-puv3.o
	drivers/video/fbdev/fb-puv3.c: In function 'unifb_mmap':
	drivers/video/fbdev/fb-puv3.c:646: error: implicit declaration of
				      function 'vm_iomap_memory'
	drivers/video/fbdev/fb-puv3.c:646: error: implicit declaration of
				      function 'pgprot_noncached'

Signed-off-by: Zhichuang Sun <sunzc522@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Joe Perches <joe@perches.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org
Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/fb-puv3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fb-puv3.c b/drivers/video/fb-puv3.c
index 27fc956166fa..520112531eb0 100644
--- a/drivers/video/fb-puv3.c
+++ b/drivers/video/fb-puv3.c
@@ -18,8 +18,10 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/console.h>
+#include <linux/mm.h>
 
 #include <asm/sizes.h>
+#include <asm/pgtable.h>
 #include <mach/hardware.h>
 
 /* Platform_data reserved for unifb registers. */
-- 
2.0.0

