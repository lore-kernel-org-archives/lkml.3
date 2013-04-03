Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560Ab3DCNGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:06:43 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:38551 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3DCNGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:06:42 -0400
MIME-Version: 1.0
Date: Wed, 3 Apr 2013 21:06:40 +0800
Message-ID: <CAPgLHd9u8Nhfa-7dp_atXfLb-vRBzdqVbrCbPSd5xMmh2Q5THg@mail.gmail.com>
Subject: [PATCH -next] mxs/spi: fix error return code in mxs_spi_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-mxs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 7b1c014..8498276 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -570,6 +570,7 @@ static int mxs_spi_probe(struct platform_device *pdev)
 	ssp->dmach = dma_request_slave_channel(&pdev->dev, "rx-tx");
 	if (!ssp->dmach) {
 		dev_err(ssp->dev, "Failed to request DMA\n");
+		ret = -ENODEV;
 		goto out_master_free;
 	}
 

