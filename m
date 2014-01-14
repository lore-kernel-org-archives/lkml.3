Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaANL7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:59:20 -0500
Received: from sauhun.de ([89.238.76.85]:47827 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaANL7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:59:18 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 1/7] arch/mips/lantiq/xway: don't check resource with devm_ioremap_resource
Date: Tue, 14 Jan 2014 12:58:52 +0100
Message-Id: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: John Crispin <blogic@openwrt.org>
---

Should go via subsystem tree

 arch/mips/lantiq/xway/dma.c | 4 ----
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
1.8.5.1

