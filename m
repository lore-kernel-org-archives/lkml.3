Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3AUKJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:09:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3AUKJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:36 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: [PATCH 05/33] ata: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:08:58 +0100
Message-Id: <1358762966-20791-6-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:C0SUq/V5UrMXXRB+LgY/xh5jRQvhkxQFMy87hOT40CW
 Wdjg03xLRDfXyMEis3bn/35U1LmgJ4NHDd5vo3x6uODYMu3/Rg
 1EPh2W3ajJwLg/HK3LeguRaovbh4kwU1tm6BRndf9RrYioE08D
 QfO1RsiHzfoFUrCTd8U72KfkaCj13c90x9+bSaMS+6vHdyoEqm
 Omj6ZgchpdnkO5v0LvSTjDhtMySgmkC5TjNekAdLzRC2jX6wnO
 matAnRl9R5lK6rSZ9Sds7dlFL1ExEZtnkg3TSJenYJacw6i0Xh
 gOYyH0ju64r87ZUNd+eiQ5cS8rVXB2p4Jy9PZ2VA9Ff43PoUZ2
 iBNgOLKNmUc/Qn7IrvbgA/AK3+cx/NfE7n9AeEpEsdYcxP/j4l
 GbeFy3waYd8P0DUe/R1gbYNX4v+RDWXzJ2XYPIe+Bu4bVPS6uw
 740+q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/pata_ep93xx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index 556222f..c1bfaf4 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -31,6 +31,7 @@
  *   Copyright (C) 2006 Tower Technologies
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -937,9 +938,9 @@ static int ep93xx_pata_probe(struct platform_device *pdev)
 		goto err_rel_gpio;
 	}
 
-	ide_base = devm_request_and_ioremap(&pdev->dev, mem_res);
-	if (!ide_base) {
-		err = -ENXIO;
+	ide_base = devm_ioremap_resource(&pdev->dev, mem_res);
+	if (IS_ERR(ide_base)) {
+		err = PTR_ERR(ide_base);
 		goto err_rel_gpio;
 	}
 
-- 
1.8.1.1

