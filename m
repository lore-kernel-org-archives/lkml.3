Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3EJIQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:16:18 -0400
Received: from sauhun.de ([89.238.76.85]:60325 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3EJIQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:16 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [RFC 01/42] drivers/ata: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:46 +0200
Message-Id: <1368173847-5661-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/ata/pata_ep93xx.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index c1bfaf4..980b88e 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -933,11 +933,6 @@ static int ep93xx_pata_probe(struct platform_device *pdev)
 	}
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		err = -ENXIO;
-		goto err_rel_gpio;
-	}
-
 	ide_base = devm_ioremap_resource(&pdev->dev, mem_res);
 	if (IS_ERR(ide_base)) {
 		err = PTR_ERR(ide_base);
-- 
1.7.10.4

