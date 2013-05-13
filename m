Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3EMKnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:43:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:9080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab3EMKnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:43:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="240707340"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/3] spi/pxa2xx: fix compile warning in pxa2xx_spi_acpi_get_pdata()
Date: Mon, 13 May 2013 13:45:09 +0300
Message-Id: <1368441911-6562-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cbfd6a21b6f (spi/pxa2xx: Convert to devm_ioremap_resource())
converted the driver to use devm_ioremap_resource(). However it causes
following warning to be emitted:

drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_acpi_get_pdata’:
drivers/spi/spi-pxa2xx.c:1094:3: warning: return makes pointer from integer without a cast [enabled by default]

Fix this by returning NULL as it was done previously (error printing is
already done by devm_ioremap_resource()).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/spi/spi-pxa2xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index f5d84d6..e5d7823 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1091,7 +1091,7 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 	ssp->phys_base = res->start;
 	ssp->mmio_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ssp->mmio_base))
-		return PTR_ERR(ssp->mmio_base);
+		return NULL;
 
 	ssp->clk = devm_clk_get(&pdev->dev, NULL);
 	ssp->irq = platform_get_irq(pdev, 0);
-- 
1.7.10.4

