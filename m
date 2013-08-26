Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3HZM2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:28:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61020 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3HZM2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:28:02 -0400
Date: Mon, 26 Aug 2013 14:27:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Koul, Vinod" <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] DMA: shdma: fix a bad merge - remove free_irq()
Message-ID: <Pine.LNX.4.64.1308261426320.1767@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:FRh5/twE0SbNHzZW/XHP4enJ0EnhRCI5kUPx0ndIG3y
 EUv+VsmqlE4rKAWOh4dPtPcg71LMYijc0AkigCVkLRqCmtHS6r
 dkGck5iiJkuk2VlucOzArcz7YsrkYDkK77suqoQxKn7FKViT8d
 EPt7zgGURVnHyg9bV7j0vLHh7oM2qJ4sXYWALUultqPXCDDZKG
 jylD9KoyJyF/jS4h0L6OT3ybHcSpxvxX8L1YO3O8bdyIHmN7Hb
 LlLkUOp4x4t0WMpR41fUIzboM2KCIT7XCQcOr8Ajith3gKBBO1
 FRrC1bsXEWprnJqdBvvrS5DFdYvlmQHLd2p9j9BFviRYvurEqm
 SHc2JUxOwEgPajwoeXhIlTmetePOQbnCFBjy/wdT/HpvRh+pSM
 3K1fFtb1ZjYvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bad merge resulted in a left-over free_irq() call. This patch removes it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

Against today's dma-slave next branch.

 drivers/dma/sh/shdmac.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index c7faded..8f1683d 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -894,14 +894,9 @@ static int sh_dmae_remove(struct platform_device *pdev)
 {
 	struct sh_dmae_device *shdev = platform_get_drvdata(pdev);
 	struct dma_device *dma_dev = &shdev->shdma_dev.dma_dev;
-	struct resource *res;
-	int errirq = platform_get_irq(pdev, 0);
 
 	dma_async_device_unregister(dma_dev);
 
-	if (errirq > 0)
-		free_irq(errirq, shdev);
-
 	spin_lock_irq(&sh_dmae_lock);
 	list_del_rcu(&shdev->node);
 	spin_unlock_irq(&sh_dmae_lock);
-- 
1.7.2.5

