Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaHWSh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:37:29 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:62560
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbaHWShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:37:04 -0400
X-IronPort-AV: E=Sophos;i="5.04,387,1406584800"; 
   d="scan'208";a="76200911"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] MIPS: Alchemy: au1200fb: delete double assignment
Date: Sat, 23 Aug 2014 20:33:28 +0200
Message-Id: <1408818808-18850-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

Not compiled.

 drivers/video/fbdev/au1200fb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index 40494db..18600d4 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1254,7 +1254,6 @@ static void set_global(u_int cmd, struct au1200_lcd_global_regs_t *pdata)
 			pdata->brightness = 30;
 		}
 		divider = (lcd->pwmdiv & 0x3FFFF) + 1;
-		hi1 = (lcd->pwmhi >> 16) + 1;
 		hi1 = (((pdata->brightness & 0xFF)+1) * divider >> 8);
 		lcd->pwmhi &= 0xFFFF;
 		lcd->pwmhi |= (hi1 << 16);

