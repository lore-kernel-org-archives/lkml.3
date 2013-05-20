Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3ETKzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:55:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56474 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab3ETKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 113/115] pch_dma: Use GFP_ATOMIC because called from interrupt context
Date: Mon, 20 May 2013 11:51:53 +0100
Message-Id: <1369047116-9378-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 5c1ef59168c485318e40ba485c1eba57d81d0faa upstream.

pdc_desc_get() is called from pd_prep_slave_sg, and the function is
called from interrupt context(e.g. Uart driver "pch_uart.c").
In fact, I saw kernel error message.
So, GFP_ATOMIC must be used not GFP_NOIO.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/pch_dma.c | 2 +-
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
1.8.1.2

