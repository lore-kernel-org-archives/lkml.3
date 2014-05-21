Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaEUHcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:32:25 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:41370 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaEUHcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:32:24 -0400
X-Greylist: delayed 2454 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 03:32:23 EDT
From: sunzc522@gmail.com
To: linux-kernel@vger.kernel.org
Cc: gxt@mprc.pku.edu.cn, gang.chen.5i5j@gmail.com,
        Zhichuang SUN <sunzc522@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH] drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap
Date: Wed, 21 May 2014 14:13:30 +0800
Message-Id: <1400652811-5206-1-git-send-email-sunzc522@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhichuang SUN <sunzc522@gmail.com>

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
---
 drivers/video/fbdev/fb-puv3.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fbdev/fb-puv3.c b/drivers/video/fbdev/fb-puv3.c
index 6db9ebd..88fa2e7 100644
--- a/drivers/video/fbdev/fb-puv3.c
+++ b/drivers/video/fbdev/fb-puv3.c
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
1.7.0.4

