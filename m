Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3CNJIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:08:18 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:41285 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3CNJIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:08:17 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: spi: Use PTR_RET function
Date: Thu, 14 Mar 2013 11:07:31 +0200
Message-Id: <1363252051-29362-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to IS_ERR and PTR_ERR with PTR_RET function.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/spi/spi-fsl-spi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 086a9ee..1985ba3 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -1134,9 +1134,7 @@ static int plat_mpc8xxx_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	master = fsl_spi_probe(&pdev->dev, mem, irq);
-	if (IS_ERR(master))
-		return PTR_ERR(master);
-	return 0;
+	return PTR_RET(master);
 }
 
 static int plat_mpc8xxx_spi_remove(struct platform_device *pdev)
-- 
1.7.9.5

