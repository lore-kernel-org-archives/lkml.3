Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaI2IKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:10:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34331 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaI2IKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:10:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <t-kristo@ti.com>, <mturquette@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: ti: dra7-atl-clock: Mark the device as pm_runtime_irq_safe
Date: Mon, 29 Sep 2014 11:10:33 +0300
Message-ID: <1411978233-25139-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is safe to call the pm sync calls in interrupt context in this driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/clk/ti/clk-dra7-atl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index af29359677da..f18d149acd65 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -228,6 +228,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 	cinfo->iobase = of_iomap(node, 0);
 	cinfo->dev = &pdev->dev;
 	pm_runtime_enable(cinfo->dev);
+	pm_runtime_irq_safe(cinfo->dev);
 
 	pm_runtime_get_sync(cinfo->dev);
 	atl_write(cinfo, DRA7_ATL_PCLKMUX_REG(0), DRA7_ATL_PCLKMUX);
-- 
2.1.0

