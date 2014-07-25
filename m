Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814AbaGYRCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:02:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaGYRCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:02:44 -0400
Message-ID: <53D28DAF.9090506@infradead.org>
Date: Fri, 25 Jul 2014 10:02:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dmaengine@vger.kernel.org
Subject: [PATCH -next] dma/sh: fix rcar-dma.c printk format warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix printk format warnings by using size_t modifiers ('z'):

../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects argument of type 'unsigned int', but argument 9 has type 'size_t' [-Wformat=]
../drivers/dma/sh/rcar-dmac.c:759:4: warning: format '%u' expects argument of type 'unsigned int', but argument 10 has type 'size_t' [-Wformat=]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org
---
 drivers/dma/sh/rcar-dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next-20140725/drivers/dma/sh/rcar-dmac.c
===================================================================
--- linux-next-20140725.orig/drivers/dma/sh/rcar-dmac.c
+++ linux-next-20140725/drivers/dma/sh/rcar-dmac.c
@@ -757,7 +757,7 @@ rcar_dmac_chan_prep_sg(struct rcar_dmac_
 			hwdesc->size = size;
 
 			dev_dbg(chan->chan.device->dev,
-				"chan%u: hwdesc %p/%p sgl %u@%p, %u/%u %pad -> %pad\n",
+				"chan%u: hwdesc %p/%p sgl %u@%p, %zu/%zu %pad -> %pad\n",
 				chan->index, hwdesc, desc, i, sg, size, len,
 				&hwdesc->src_addr, &hwdesc->dst_addr);
 
