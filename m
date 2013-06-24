Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3FXRyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:54:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57716 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FXRyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:54:44 -0400
Message-ID: <51C887CC.6000301@infradead.org>
Date: Mon, 24 Jun 2013 10:54:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/2 v2] fb: fix atyfb unused data warnings
References: <51C26B56.20802@infradead.org> <20130624143737.GI305@game.jcrosoft.org>
In-Reply-To: <20130624143737.GI305@game.jcrosoft.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix compiler warnings of data defined but not used by using the
__maybe_unused attribute.  The date are only used with certain kconfig
settings.

drivers/video/aty/atyfb_base.c:534:13: warning: 'ram_dram' defined but not used [-Wunused-variable]
drivers/video/aty/atyfb_base.c:535:13: warning: 'ram_resv' defined but not used [-Wunused-variable]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Paul Mackerras <paulus@samba.org>
Cc:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:	linux-fbdev@vger.kernel.org
Cc:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc:	Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/aty/atyfb_base.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- lnx-310-rc7.orig/drivers/video/aty/atyfb_base.c
+++ lnx-310-rc7/drivers/video/aty/atyfb_base.c
@@ -58,6 +58,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
+#include <linux/compiler.h>
 #include <linux/console.h>
 #include <linux/fb.h>
 #include <linux/init.h>
@@ -531,8 +532,8 @@ static int correct_chipset(struct atyfb_
 	return 0;
 }
 
-static char ram_dram[] = "DRAM";
-static char ram_resv[] = "RESV";
+static char ram_dram[] __maybe_unused = "DRAM";
+static char ram_resv[] __maybe_unused = "RESV";
 #ifdef CONFIG_FB_ATY_GX
 static char ram_vram[] = "VRAM";
 #endif /* CONFIG_FB_ATY_GX */
