Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966627AbaFTVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:51:29 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42521 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:51:27 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] video: Remove kfree call since devm_kzalloc() is used
Date: Fri, 20 Jun 2014 23:50:37 +0200
Message-Id: <1403301037-10699-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use devm_kzalloc() to allocate memory for the struct vt8500lcd_info
pointer fbi, so there is no need to free it in vt8500lcd_remove().

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/video/fbdev/vt8500lcdfb.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
index a8f2b28..a1134c3 100644
--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -474,8 +474,6 @@ static int vt8500lcd_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
 
-	kfree(fbi);
-
 	return 0;
 }
 
-- 
1.7.10.4

