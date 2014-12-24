Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaLXV5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 16:57:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42641 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaLXV5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 16:57:30 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <will.deacon@arm.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] dma-mapping: fix size when of_dma_get_range() fails
Date: Wed, 24 Dec 2014 16:56:50 -0500
Message-ID: <1419458210-4079-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When call to of_dma_get_range() fails, the code currently set size
to dev->coherent_dma_mask instead of dev->coherent_dma_mask + 1. Fix this
to make the code consistent with the case when size is obtained from
dma-range property.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/of/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index a54ec10..af9aef1 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -185,7 +185,7 @@ static void of_dma_configure(struct device *dev)
 	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
 	if (ret < 0) {
 		dma_addr = offset = 0;
-		size = dev->coherent_dma_mask;
+		size = dev->coherent_dma_mask + 1;
 	} else {
 		offset = PFN_DOWN(paddr - dma_addr);
 		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
-- 
1.7.9.5

