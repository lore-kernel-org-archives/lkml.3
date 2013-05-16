Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3EPLPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:00 -0400
Received: from sauhun.de ([89.238.76.85]:56115 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3EPLOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:14:53 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 11/33] drivers/misc: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:39 +0200
Message-Id: <1368702961-4325-12-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/misc/atmel-ssc.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index c09c28f..1abd5ad 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -154,11 +154,6 @@ static int ssc_probe(struct platform_device *pdev)
 	ssc->pdata = (struct atmel_ssc_platform_data *)plat_dat;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		dev_dbg(&pdev->dev, "no mmio resource defined\n");
-		return -ENXIO;
-	}
-
 	ssc->regs = devm_ioremap_resource(&pdev->dev, regs);
 	if (IS_ERR(ssc->regs))
 		return PTR_ERR(ssc->regs);
-- 
1.7.10.4

