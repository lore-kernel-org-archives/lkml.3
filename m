Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaAPMvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:51:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:59726 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbaAPMu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:50:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="467637162"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-spi@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] spi/pxa2xx: fix compilation warning when !CONFIG_PM_SLEEP
Date: Thu, 16 Jan 2014 14:50:55 +0200
Message-Id: <1389876655-5484-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PM will be set if either or both CONFIG_PM_SLEEP and
CONFIG_PM_RUNTIME is set. Compiling the driver with !CONFIG_PM_SLEEP causes
following compilation warning:

drivers/spi/spi-pxa2xx.c:1270:12: warning: ‘pxa2xx_spi_suspend’ defined but not used [-Wunused-function]

Fix this by using CONFIG_PM_SLEEP instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index cbc68848789d..c702fc536a77 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1268,7 +1268,7 @@ static void pxa2xx_spi_shutdown(struct platform_device *pdev)
 		dev_err(&pdev->dev, "shutdown failed with %d\n", status);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pxa2xx_spi_suspend(struct device *dev)
 {
 	struct driver_data *drv_data = dev_get_drvdata(dev);
-- 
1.8.5.2

