Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3EQVza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:55:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3EQVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [ 25/33] pch_dma: Use GFP_ATOMIC because called from interrupt context
Date: Fri, 17 May 2013 14:50:09 -0700
Message-Id: <20130517214919.555635825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 5c1ef59168c485318e40ba485c1eba57d81d0faa upstream.

pdc_desc_get() is called from pd_prep_slave_sg, and the function is
called from interrupt context(e.g. Uart driver "pch_uart.c").
In fact, I saw kernel error message.
So, GFP_ATOMIC must be used not GFP_NOIO.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/pch_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -489,7 +489,7 @@ static struct pch_dma_desc *pdc_desc_get
 	dev_dbg(chan2dev(&pd_chan->chan), "scanned %d descriptors\n", i);
 
 	if (!ret) {
-		ret = pdc_alloc_desc(&pd_chan->chan, GFP_NOIO);
+		ret = pdc_alloc_desc(&pd_chan->chan, GFP_ATOMIC);
 		if (ret) {
 			spin_lock(&pd_chan->lock);
 			pd_chan->descs_allocated++;


