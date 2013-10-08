Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3JHUhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:37:20 -0400
Received: from sauhun.de ([89.238.76.85]:52217 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab3JHUgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:36:00 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] spi: spi-bfin5xx: replace platform_driver_probe to support deferred probing
Date: Tue,  8 Oct 2013 22:35:38 +0200
Message-Id: <1381264542-29396-7-git-send-email-wsa@the-dreams.de>
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
 drivers/spi/spi-bfin5xx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
index 45bdf73..a563bd5 100644
--- a/drivers/spi/spi-bfin5xx.c
+++ b/drivers/spi/spi-bfin5xx.c
@@ -1462,12 +1462,13 @@ static struct platform_driver bfin_spi_driver = {
 	},
 	.suspend	= bfin_spi_suspend,
 	.resume		= bfin_spi_resume,
-	.remove		= bfin_spi_remove,
+	.probe = bfin_spi_probe,
+	.remove = bfin_spi_remove,
 };
 
 static int __init bfin_spi_init(void)
 {
-	return platform_driver_probe(&bfin_spi_driver, bfin_spi_probe);
+	return platform_driver_register(&bfin_spi_driver);
 }
 subsys_initcall(bfin_spi_init);
 
-- 
1.8.4.rc3

