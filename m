Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbbAGFgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:36:04 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55248 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbbAGFgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:36:01 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v2] video: vt8500lcdfb: remove unneeded continue
Date: Wed,  7 Jan 2015 11:05:48 +0530
Message-Id: <1420608948-4550-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

continue is not needed at the end of a for loop, also removed the
braces which were no longer required.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v2: removed braces

 drivers/video/fbdev/vt8500lcdfb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
index ffaf29e..1a1176b 100644
--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -113,10 +113,8 @@ static int vt8500lcd_set_par(struct fb_info *info)
 	}
 
 	for (i = 0; i < 8; i++) {
-		if (bpp_values[i] == info->var.bits_per_pixel) {
+		if (bpp_values[i] == info->var.bits_per_pixel)
 			reg_bpp = i;
-			continue;
-		}
 	}
 
 	control0 = readl(fbi->regbase) & ~0xf;
-- 
1.8.1.2

