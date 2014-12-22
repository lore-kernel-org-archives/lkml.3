Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaLVPfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:35:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42765 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118AbaLVPfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:35:39 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] dma-mapping: fix debug print to display correct dma_pfn_offset
Date: Mon, 22 Dec 2014 10:35:09 -0500
Message-ID: <1419262509-9811-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the dev_dbg to display the offset which is the calculated
dma_pfn_offset value and set later in the code.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/of/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 5b33c6a..a54ec10 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -188,7 +188,7 @@ static void of_dma_configure(struct device *dev)
 		size = dev->coherent_dma_mask;
 	} else {
 		offset = PFN_DOWN(paddr - dma_addr);
-		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
+		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
 	}
 	dev->dma_pfn_offset = offset;
 
-- 
1.7.9.5

