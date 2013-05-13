Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3EMGzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:55:55 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:54640 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3EMGzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:55:53 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 14:55:52 +0800
Message-ID: <CAPgLHd_ETnhT-YQgyPKJJ5meTF_mibYipShRO2GPGMhpdGOuyw@mail.gmail.com>
Subject: [PATCH] mtd: fsmc_nand: fix error return code in fsmc_nand_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        artem.bityutskiy@linux.intel.com, linus.walleij@linaro.org,
        viresh.kumar@linaro.org, vipin.kumar@st.com
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENODEV in the dma channel request error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/nand/fsmc_nand.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 911e243..6988fc8 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -1032,6 +1032,7 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 	case USE_DMA_ACCESS:
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_MEMCPY, mask);
+		ret = -ENODEV;
 		host->read_dma_chan = dma_request_channel(mask, filter,
 				pdata->read_dma_priv);
 		if (!host->read_dma_chan) {

