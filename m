Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbbAHISM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:18:12 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:50532 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbbAHISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:18:10 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] fbdev: ssd1307fb: set default height if not found in DT node
Date: Thu,  8 Jan 2015 08:17:58 +0000
Message-Id: <1420705079-3741-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch sets the default height if its not found in DT.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/video/fbdev/ssd1307fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index f4daa59..70e3ce8 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -460,7 +460,7 @@ static int ssd1307fb_probe(struct i2c_client *client,
 		par->width = 96;
 
 	if (of_property_read_u32(node, "solomon,height", &par->height))
-		par->width = 16;
+		par->height = 16;
 
 	if (of_property_read_u32(node, "solomon,page-offset", &par->page_offset))
 		par->page_offset = 1;
-- 
1.9.1

