Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaGHAXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:23:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbaGGXzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhichuang Sun <sunzc522@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-fbdev@vger.kernel.org, Xuetao Guan <gxt@mprc.pku.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.14 91/94] drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap
Date: Mon,  7 Jul 2014 16:58:21 -0700
Message-Id: <20140707235759.447179528@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhichuang SUN <sunzc522@gmail.com>

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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fb-puv3.c |    2 ++
 1 file changed, 2 insertions(+)

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


