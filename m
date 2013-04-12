Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3DLGvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 02:51:23 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49938 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3DLGvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 02:51:22 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: ata: rcar: use devm_ioremap_resource()
Date: Fri, 12 Apr 2013 09:51:17 +0300
Message-Id: <1365749477-22770-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert  use of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.
This was found with coccinelle.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/ata/sata_rcar.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
index caf33f6..8c51a3a 100644
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -799,9 +799,9 @@ static int sata_rcar_probe(struct platform_device *pdev)
 
 	host->private_data = priv;
 
-	priv->base = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!priv->base) {
-		ret = -EADDRNOTAVAIL;
+	priv->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(priv->base)) {
+		ret = PTR_ERR(priv->base);
 		goto cleanup;
 	}
 
-- 
1.7.9.5

