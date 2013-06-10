Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3FJLuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32814 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3FJLuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:18 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 07/15] net: fec: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:05 +0530
Message-Id: <1370864113-17895-8-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/ethernet/freescale/fec_main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c42c42a..b0d36b7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1876,17 +1876,17 @@ fec_probe(struct platform_device *pdev)
 	    (pdev->id_entry->driver_data & FEC_QUIRK_HAS_GBIT))
 		fep->pause_flag |= FEC_PAUSE_FLAG_AUTONEG;
 
-	fep->hwp = devm_request_and_ioremap(&pdev->dev, r);
+	fep->hwp = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(fep->hwp)) {
+		ret = PTR_ERR(fep->hwp);
+		goto failed_ioremap;
+	}
+
 	fep->pdev = pdev;
 	fep->dev_id = dev_id++;
 
 	fep->bufdesc_ex = 0;
 
-	if (!fep->hwp) {
-		ret = -ENOMEM;
-		goto failed_ioremap;
-	}
-
 	platform_set_drvdata(pdev, ndev);
 
 	ret = of_get_phy_mode(pdev->dev.of_node);
-- 
1.7.9.5

