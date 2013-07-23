Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab3GWSCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:02:24 -0400
Received: from sauhun.de ([89.238.76.85]:58681 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab3GWSCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:02:23 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 01/27] arch/mips/lantiq/xway: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:34 +0200
Message-Id: <1374602524-3398-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 arch/mips/lantiq/xway/dma.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 08f7ebd..78a91fa 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -220,10 +220,6 @@ ltq_dma_init(struct platform_device *pdev)
 	int i;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		panic("Failed to get dma resource");
-
-	/* remap dma register range */
 	ltq_dma_membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ltq_dma_membase))
 		panic("Failed to remap dma resource");
-- 
1.7.10.4

