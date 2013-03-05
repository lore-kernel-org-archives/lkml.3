Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3CEKDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:03:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:45499 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab3CEKDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:03:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,786,1355126400"; 
   d="scan'208";a="271209591"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/2] spi/pxa2xx-pci: correct the return value check of pcim_iomap_regions()
Date: Tue,  5 Mar 2013 12:05:16 +0200
Message-Id: <1362477917-24904-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function returns 0 on success and negative errno in case of failure.
Fix this.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 364964d..48abae5 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -22,7 +22,7 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 		return ret;
 
 	ret = pcim_iomap_regions(dev, 1 << 0, "PXA2xx SPI");
-	if (!ret)
+	if (ret)
 		return ret;
 
 	memset(&spi_pdata, 0, sizeof(spi_pdata));
-- 
1.7.10.4

