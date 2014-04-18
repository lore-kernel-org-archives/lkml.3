Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaDRITC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:19:02 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:52038
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbaDRISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:18:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <leo.li@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v4 1/8] DMA: Freescale: remove the unnecessary FSL_DMA_LD_DEBUG
Date: Fri, 18 Apr 2014 16:17:44 +0800
Message-ID: <1397809071-5353-2-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Some codes are calling chan_dbg with FSL_DMA_LD_DEBUG surrounded, it is really
unnecessary to use such a macro because chan_dbg is a wrapper of dev_dbg, we do
have corresponding DEBUG macro to switch on/off dev_dbg, and most of the other
codes are also calling chan_dbg directly without using FSL_DMA_LD_DEBUG.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index f157c6f..ec50420 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -426,9 +426,7 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(struct fsldma_chan *chan)
 	desc->async_tx.tx_submit = fsl_dma_tx_submit;
 	desc->async_tx.phys = pdesc;
 
-#ifdef FSL_DMA_LD_DEBUG
 	chan_dbg(chan, "LD %p allocated\n", desc);
-#endif
 
 	return desc;
 }
@@ -479,9 +477,7 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
 
 	list_for_each_entry_safe(desc, _desc, list, node) {
 		list_del(&desc->node);
-#ifdef FSL_DMA_LD_DEBUG
 		chan_dbg(chan, "LD %p free\n", desc);
-#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 }
@@ -493,9 +489,7 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 
 	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
 		list_del(&desc->node);
-#ifdef FSL_DMA_LD_DEBUG
 		chan_dbg(chan, "LD %p free\n", desc);
-#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 }
@@ -832,9 +826,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 
 	/* Run the link descriptor callback function */
 	if (txd->callback) {
-#ifdef FSL_DMA_LD_DEBUG
 		chan_dbg(chan, "LD %p callback\n", desc);
-#endif
 		txd->callback(txd->callback_param);
 	}
 
@@ -842,9 +834,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 	dma_run_dependencies(txd);
 
 	dma_descriptor_unmap(txd);
-#ifdef FSL_DMA_LD_DEBUG
 	chan_dbg(chan, "LD %p free\n", desc);
-#endif
 	dma_pool_free(chan->desc_pool, desc, txd->phys);
 }
 
-- 
1.7.9.5



