Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3FHPq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 11:46:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21323 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762Ab3FHPq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 11:46:27 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jun 2013 11:46:27 EDT
X-IronPort-AV: E=Sophos;i="4.87,827,1363129200"; 
   d="scan'208";a="20969327"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>, zajec5@gmail.com
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mtd/devices/bcm47xxsflash.c: correct argument to kfree
Date: Sat,  8 Jun 2013 17:36:23 +0200
Message-Id: <1370705783-2140-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The argument to kfree should not be the address of a structure field.
The argument is adjusted to correspond to what is found in the subsequent
remove function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
identifier f;
@@

* kfree(&e->f)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/devices/bcm47xxsflash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
index 2060856..59848e7 100644
--- a/drivers/mtd/devices/bcm47xxsflash.c
+++ b/drivers/mtd/devices/bcm47xxsflash.c
@@ -155,7 +155,7 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
 	return 0;
 
 err_dev_reg:
-	kfree(&b47s->mtd);
+	kfree(b47s);
 out:
 	return err;
 }

