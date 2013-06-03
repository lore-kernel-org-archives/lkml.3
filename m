Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3FCWNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:13:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621Ab3FCWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:43 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ixUr85OyRgUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xzWxqGRNOOUA:10 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221159.809766434@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Vinod Koul <vinod.koul@intel.com>
Subject: [44/65] pch_dma: Use GFP_ATOMIC because called from interrupt context
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0044-pch_dma-Use-GFP_ATOMIC-because-called-from-interrupt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

[ Upstream commit 5c1ef59168c485318e40ba485c1eba57d81d0faa ]

pdc_desc_get() is called from pd_prep_slave_sg, and the function is
called from interrupt context(e.g. Uart driver "pch_uart.c").
In fact, I saw kernel error message.
So, GFP_ATOMIC must be used not GFP_NOIO.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/dma/pch_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 987ab5c..d5cbd44 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -476,7 +476,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
 	dev_dbg(chan2dev(&pd_chan->chan), "scanned %d descriptors\n", i);
 
 	if (!ret) {
-		ret = pdc_alloc_desc(&pd_chan->chan, GFP_NOIO);
+		ret = pdc_alloc_desc(&pd_chan->chan, GFP_ATOMIC);
 		if (ret) {
 			spin_lock(&pd_chan->lock);
 			pd_chan->descs_allocated++;
-- 
1.7.10.4


