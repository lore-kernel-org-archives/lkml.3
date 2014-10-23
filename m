Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500AbaJWD2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:28:37 -0400
Received: from [157.56.110.110] ([157.56.110.110]:45600 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932513AbaJWD2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:28:34 -0400
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <andriy.shevchenko@linux.intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <b38343@freescale.com>
Subject: [PATCH v5 2/3] dma: imx-sdma: correct the printk format
Date: Thu, 23 Oct 2014 10:22:19 +0800
Message-ID: <1414030940-15516-3-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414030940-15516-1-git-send-email-b38343@freescale.com>
References: <1414030940-15516-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(20776003)(47776003)(229853001)(48376002)(87936001)(64706001)(85306004)(21056001)(99396003)(107046002)(87286001)(76176999)(93916002)(33646002)(50986999)(26826002)(102836001)(76482002)(120916001)(104016003)(77156001)(95666004)(68736004)(2201001)(92566001)(62966002)(104166001)(31966008)(106466001)(36756003)(84676001)(50466002)(105606002)(88136002)(92726001)(50226001)(89996001)(80022003)(6806004)(97736003)(85852003)(46102003)(4396001)(19580405001)(44976005)(19580395003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB038;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB038;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0373D94D15
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the printk format for 'size_t', 'dma_address_t', etc.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/dma/imx-sdma.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 5424d9a..377bb18 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1041,7 +1041,7 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
 		return NULL;
 
 	if (len >= NUM_BD * SDMA_BD_MAX_CNT) {
-		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%d > %d\n",
+		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%zu > %d\n",
 			channel, len, NUM_BD * SDMA_BD_MAX_CNT);
 		goto err_out;
 	}
@@ -1050,8 +1050,8 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
 
 	sdmac->buf_tail = 0;
 
-	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
-		dma_src, dma_dst, len, channel);
+	dev_dbg(sdma->dev, "memcpy: %pad->%pad, len=%zu, channel=%d.\n",
+		&dma_src, &dma_dst, len, channel);
 
 	sdmac->direction = DMA_MEM_TO_MEM;
 
@@ -1104,7 +1104,7 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
 			param &= ~BD_CONT;
 		}
 
-		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%u %s%s\n",
 				i, count, bd->buffer_addr,
 				param & BD_WRAP ? "wrap" : "",
 				param & BD_INTR ? " intr" : "");
@@ -1220,8 +1220,8 @@ static struct dma_async_tx_descriptor *sdma_prep_sg(
 			param &= ~BD_CONT;
 		}
 
-		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
-				i, count, sg_src->dma_address,
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%pad %s%s\n",
+				i, count, &sg_src->dma_address,
 				param & BD_WRAP ? "wrap" : "",
 				param & BD_INTR ? " intr" : "");
 
@@ -1291,7 +1291,7 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 	}
 
 	if (period_len > SDMA_BD_MAX_CNT) {
-		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %d > %d\n",
+		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %zu > %d\n",
 				channel, period_len, SDMA_BD_MAX_CNT);
 		goto err_out;
 	}
@@ -1315,8 +1315,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 		if (i + 1 == num_periods)
 			param |= BD_WRAP;
 
-		dev_dbg(sdma->dev, "entry %d: count: %d dma: %#llx %s%s\n",
-				i, period_len, (u64)dma_addr,
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: %pad %s%s\n",
+				i, period_len, &dma_addr,
 				param & BD_WRAP ? "wrap" : "",
 				param & BD_INTR ? " intr" : "");
 
-- 
1.9.1

