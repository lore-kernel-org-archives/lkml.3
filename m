Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925AbaGASpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:45:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50421 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbaGASpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:45:31 -0400
Date: Wed, 2 Jul 2014 00:15:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] mailbox-omap1 : Use devm_ functions
Message-ID: <20140701184525.GA3030@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch intoduces the use of devm_ioremap, does away with the ret
variable. The calls to iounmap in the probe and remove functions and no
longer needed and hence removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/mailbox/mailbox-omap1.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index 9001b76..508024f 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -146,7 +146,6 @@ static struct omap_mbox *omap1_mboxes[] = { &mbox_dsp_info, NULL };
 static int omap1_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
-	int ret;
 	struct omap_mbox **list;
 
 	list = omap1_mboxes;
@@ -156,23 +155,16 @@ static int omap1_mbox_probe(struct platform_device *pdev)
 	if (!mem)
 		return -ENOENT;
 
-	mbox_base = ioremap(mem->start, resource_size(mem));
+	mbox_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
 	if (!mbox_base)
 		return -ENOMEM;
 
-	ret = omap_mbox_register(&pdev->dev, list);
-	if (ret) {
-		iounmap(mbox_base);
-		return ret;
-	}
-
-	return 0;
+	return omap_mbox_register(&pdev->dev, list);
 }
 
 static int omap1_mbox_remove(struct platform_device *pdev)
 {
 	omap_mbox_unregister();
-	iounmap(mbox_base);
 	return 0;
 }
 
-- 
1.9.1

