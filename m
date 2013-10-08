Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3JHUgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:36:43 -0400
Received: from sauhun.de ([89.238.76.85]:52223 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab3JHUgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:36:05 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] spi: spi-au1550: replace platform_driver_probe to support deferred probing
Date: Tue,  8 Oct 2013 22:35:37 +0200
Message-Id: <1381264542-29396-6-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems like pinctrl and gpio rightfully make use of deferred probing at
core level. Now, deferred drivers won't be retried if they don't have a .probe
function specified in the driver struct. Fix this driver to have that, so the
devices it supports won't get lost in a deferred probe.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/spi/spi-au1550.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-au1550.c b/drivers/spi/spi-au1550.c
index 1d00d9b3..313dd49 100644
--- a/drivers/spi/spi-au1550.c
+++ b/drivers/spi/spi-au1550.c
@@ -985,6 +985,7 @@ static int au1550_spi_remove(struct platform_device *pdev)
 MODULE_ALIAS("platform:au1550-spi");
 
 static struct platform_driver au1550_spi_drv = {
+	.probe = au1550_spi_probe,
 	.remove = au1550_spi_remove,
 	.driver = {
 		.name = "au1550-spi",
@@ -1004,7 +1005,7 @@ static int __init au1550_spi_init(void)
 			printk(KERN_ERR "au1550-spi: cannot add memory"
 					"dbdma device\n");
 	}
-	return platform_driver_probe(&au1550_spi_drv, au1550_spi_probe);
+	return platform_driver_register(&au1550_spi_drv);
 }
 module_init(au1550_spi_init);
 
-- 
1.8.4.rc3

