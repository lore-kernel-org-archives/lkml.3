Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3K0Ezy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:55:54 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50696 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3K0Ezv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:55:51 -0500
From: Olof Johansson <olof@lixom.net>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] dmaengine: pl08x: fix conversioin for generic unmap data
Date: Tue, 26 Nov 2013 20:53:24 -0800
Message-Id: <1385528004-19423-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
added a generic unmap call but used the wrong argument for it. Fix it.

Fixes: d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
Signed-off-by: Olof Johansson <olof@lixom.net>
---

I can't actually tell what the intent of d38a8cc622a1b and how mappings
are expected to be managed, but it's obviously passing the wrong thing
in here so it seems like the appropriate fix.

 drivers/dma/amba-pl08x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 16a2aa28f856..ec4ee5c1fe9d 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1169,7 +1169,7 @@ static void pl08x_desc_free(struct virt_dma_desc *vd)
 	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
 
-	dma_descriptor_unmap(txd);
+	dma_descriptor_unmap(&vd->tx);
 	if (!txd->done)
 		pl08x_release_mux(plchan);
 
-- 
1.8.4.1.601.g02b3b1d

