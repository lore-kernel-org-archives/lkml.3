Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaGRLbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:31:14 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56869 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaGRLbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:31:13 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Charulatha V <charu@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] spi: omap2-mcspi: fix blatant abuse of the resource subsystem
Date: Fri, 18 Jul 2014 13:30:53 +0200
Message-Id: <1405683053-14104-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aua. This really hurts. I wonder how this could ever be admitted to
the Linux kernel...
Further comments suppressed because the would most likely violate the
CDA.

If someone should not grasp what this patch does, they should consider
what happens upon unloading/reloading the kernel module.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/spi/spi-omap2-mcspi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 68441fa..cb23f5d 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1379,15 +1379,13 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 		goto free_master;
 	}
 
-	r->start += regs_offset;
-	r->end += regs_offset;
-	mcspi->phys = r->start;
-
 	mcspi->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(mcspi->base)) {
 		status = PTR_ERR(mcspi->base);
 		goto free_master;
 	}
+	mcspi->phys = r->start + regs_offset;
+	mcspi->base += regs_offset;
 
 	mcspi->dev = &pdev->dev;
 
-- 
1.7.10.4

