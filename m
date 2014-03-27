Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaC0QIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:08:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37269 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbaC0QII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:08:08 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [-next PATCH] spi: omap-uwire: add missing iounmap
Date: Thu, 27 Mar 2014 11:07:59 -0500
Message-ID: <1395936479-26069-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following coccicheck warning:
linux-2.6/drivers/spi/spi-omap-uwire.c:485:2-8: ERROR: missing iounmap; ioremap on line 471 and execution via conditional on line 481

Signed-off-by: Nishanth Menon <nm@ti.com>
---
based on: next-20140326 tag

 drivers/spi/spi-omap-uwire.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 95cc694..e47c9c6 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -482,6 +482,7 @@ static int uwire_probe(struct platform_device *pdev)
 		status = PTR_ERR(uwire->ck);
 		dev_dbg(&pdev->dev, "no functional clock?\n");
 		spi_master_put(master);
+		iounmap(uwire_base);
 		return status;
 	}
 	clk_enable(uwire->ck);
-- 
1.7.9.5

