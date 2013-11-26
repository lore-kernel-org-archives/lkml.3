Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3KZSqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:46:00 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60225 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3KZSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:45:59 -0500
From: Olof Johansson <olof@lixom.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, dmaengine@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] dmaengine: at_hdmac: remove unused function
Date: Tue, 26 Nov 2013 10:43:35 -0800
Message-Id: <1385491415-31325-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
refactored some code which resulted in an unused function in the at_hdmac
driver:

drivers/dma/at_hdmac_regs.h:350:23: warning: 'chan2parent' defined but
    not used [-Wunused-function]

Fixes: 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---

Dan,

Looks like you fixed up the DesignWare driver for the same issue but
this needs it to.

 drivers/dma/at_hdmac_regs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index f31d647acdfa..2787aba60c6b 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -347,10 +347,6 @@ static struct device *chan2dev(struct dma_chan *chan)
 {
 	return &chan->dev->device;
 }
-static struct device *chan2parent(struct dma_chan *chan)
-{
-	return chan->dev->device.parent;
-}
 
 #if defined(VERBOSE_DEBUG)
 static void vdbg_dump_regs(struct at_dma_chan *atchan)
-- 
1.8.4.1.601.g02b3b1d

