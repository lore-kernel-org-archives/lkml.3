Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDDFLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 01:11:10 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:15989
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbaDDFLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 01:11:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Yuan Yao <yao.yuan@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <jingchang.lu@freecsale.com>
Subject: [PATCH] dma: fix eDMA driver as a subsys_initcall
Date: Fri, 4 Apr 2014 12:27:55 +0800
Message-ID: <1396585675-32729-1-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of some driver base on DMA, changed the initcall order as subsys_initcall.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 drivers/dma/fsl-edma.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index 381e793..b396a7f 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -968,7 +968,17 @@ static struct platform_driver fsl_edma_driver = {
 	.remove		= fsl_edma_remove,
 };
 
-module_platform_driver(fsl_edma_driver);
+static int __init fsl_edma_init(void)
+{
+	return platform_driver_register(&fsl_edma_driver);
+}
+subsys_initcall(fsl_edma_init);
+
+static void __exit fsl_edma_exit(void)
+{
+	platform_driver_unregister(&fsl_edma_driver);
+}
+module_exit(fsl_edma_exit);
 
 MODULE_ALIAS("platform:fsl-edma");
 MODULE_DESCRIPTION("Freescale eDMA engine driver");
-- 
1.8.4


