Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbaFTUAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:00:24 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64442 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbaFTUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:00:22 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers/video/fbdev/sis: Add missing else
Date: Fri, 20 Jun 2014 21:59:57 +0200
Message-Id: <1403294397-18262-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The surrounding code and the fact that the previous two if's are
rendered useless without this "else" (since SIS_340==55 and XGI_20==75
are greater than SIS_661==15) suggests that the "else" is indeed
missing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/video/fbdev/sis/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/init.c
index bd40f5e..dfe3eb7 100644
--- a/drivers/video/fbdev/sis/init.c
+++ b/drivers/video/fbdev/sis/init.c
@@ -1511,7 +1511,7 @@ SiS_Get310DRAMType(struct SiS_Private *SiS_Pr)
       } else if(SiS_Pr->ChipType >= SIS_340) {
 	 /* TODO */
 	 data = 0;
-      } if(SiS_Pr->ChipType >= SIS_661) {
+      } else if(SiS_Pr->ChipType >= SIS_661) {
 	 if(SiS_Pr->SiS_ROMNew) {
 	    data = ((SiS_GetReg(SiS_Pr->SiS_P3d4,0x78) & 0xc0) >> 6);
 	 } else {
-- 
1.9.2

