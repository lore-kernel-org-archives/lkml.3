Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935576Ab3FTCjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:39:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57156 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935506Ab3FTCje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:39:34 -0400
Message-ID: <51C26B56.20802@infradead.org>
Date: Wed, 19 Jun 2013 19:39:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/2] fb: fix atyfb unused data warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix compiler warnings of data defined but not used.  They are only used
with certain kconfig settings.

drivers/video/aty/atyfb_base.c:534:13: warning: 'ram_dram' defined but not used [-Wunused-variable]
drivers/video/aty/atyfb_base.c:535:13: warning: 'ram_resv' defined but not used [-Wunused-variable]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Paul Mackerras <paulus@samba.org>
Cc:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:	linux-fbdev@vger.kernel.org
Cc:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc:	Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/aty/atyfb_base.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20130619.orig/drivers/video/aty/atyfb_base.c
+++ linux-next-20130619/drivers/video/aty/atyfb_base.c
@@ -531,8 +531,10 @@ static int correct_chipset(struct atyfb_
 	return 0;
 }
 
+#if defined(CONFIG_FB_ATY_GX) || defined(CONFIG_FB_ATY_CT)
 static char ram_dram[] = "DRAM";
 static char ram_resv[] = "RESV";
+#endif
 #ifdef CONFIG_FB_ATY_GX
 static char ram_vram[] = "VRAM";
 #endif /* CONFIG_FB_ATY_GX */
