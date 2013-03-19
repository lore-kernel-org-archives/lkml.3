Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3CSHrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:47:15 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:27710 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752754Ab3CSHrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:47:14 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <broonie@opensource.wolfsonmicro.com>,
        <richard.genoud@gmail.com>, <plagnioj@jcrosoft.com>,
        <nicolas.ferre@atmel.com>, <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 03/14] spi/spi-atmel: add physical base address
Date: Tue, 19 Mar 2013 15:43:36 +0800
Message-ID: <1363679016-3761-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Needed for future use with dmaengine enabled driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/spi/spi-atmel.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 64e2795..f3e1cd8 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -196,6 +196,7 @@ struct atmel_spi_caps {
 struct atmel_spi {
 	spinlock_t		lock;
 
+	resource_size_t		phybase;
 	void __iomem		*regs;
 	int			irq;
 	struct clk		*clk;
@@ -993,6 +994,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	as->regs = ioremap(regs->start, resource_size(regs));
 	if (!as->regs)
 		goto out_free_buffer;
+	as->phybase = regs->start;
 	as->irq = irq;
 	as->clk = clk;
 
-- 
1.7.9.5

