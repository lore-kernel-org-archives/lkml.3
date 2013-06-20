Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965071Ab3FTCid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:38:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57138 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025Ab3FTCic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:38:32 -0400
Message-ID: <51C26B15.3090800@infradead.org>
Date: Wed, 19 Jun 2013 19:38:13 -0700
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
Subject: [PATCH 1/2] fb: fix atyfb build warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build warning when neither of CONFIG_FB_ATY_GX or
CONFIG_FB_ATY_CT is enabled, since ARRAY_SIZE(aty_chips) is 0 in
that case.

drivers/video/aty/atyfb_base.c:437:11: warning: overflow in implicit constant conversion [-Woverflow]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Paul Mackerras <paulus@samba.org>
Cc:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:	linux-fbdev@vger.kernel.org
Cc:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc:	Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/aty/atyfb_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20130619.orig/drivers/video/aty/atyfb_base.c
+++ linux-next-20130619/drivers/video/aty/atyfb_base.c
@@ -434,8 +434,8 @@ static int correct_chipset(struct atyfb_
 	const char *name;
 	int i;
 
-	for (i = ARRAY_SIZE(aty_chips) - 1; i >= 0; i--)
-		if (par->pci_id == aty_chips[i].pci_id)
+	for (i = ARRAY_SIZE(aty_chips); i > 0; i--)
+		if (par->pci_id == aty_chips[i - 1].pci_id)
 			break;
 
 	if (i < 0)
