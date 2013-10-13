Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3JMGVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:21:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56271 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726Ab3JMGVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:21:35 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] mtd: nand: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:21:32 +0200
Message-Id: <1381645292-9499-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/mtd/nand/mxc_nand.c    | 2 +-
 drivers/mtd/nand/pxa3xx_nand.c | 3 +--
 drivers/mtd/nand/tmio_nand.c   | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index ce8242b..58edc85 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1507,7 +1507,7 @@ static int mxcnd_probe(struct platform_device *pdev)
 	host->devtype_data->irq_control(host, 0);
 
 	err = devm_request_irq(&pdev->dev, host->irq, mxc_nfc_irq,
-			IRQF_DISABLED, DRIVER_NAME, host);
+			0, DRIVER_NAME, host);
 	if (err)
 		return err;
 
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index dd03dfd..78a79a0 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1194,8 +1194,7 @@ static int alloc_nand_resource(struct platform_device *pdev)
 	/* initialize all interrupts to be disabled */
 	disable_int(info, NDSR_MASK);
 
-	ret = request_irq(irq, pxa3xx_nand_irq, IRQF_DISABLED,
-			  pdev->name, info);
+	ret = request_irq(irq, pxa3xx_nand_irq, 0, pdev->name, info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
 		goto fail_free_buf;
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index 396530d..a3747c9 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -428,8 +428,7 @@ static int tmio_probe(struct platform_device *dev)
 	/* 15 us command delay time */
 	nand_chip->chip_delay = 15;
 
-	retval = request_irq(irq, &tmio_irq,
-				IRQF_DISABLED, dev_name(&dev->dev), tmio);
+	retval = request_irq(irq, &tmio_irq, 0, dev_name(&dev->dev), tmio);
 	if (retval) {
 		dev_err(&dev->dev, "request_irq error %d\n", retval);
 		goto err_irq;
-- 
1.8.1.2

