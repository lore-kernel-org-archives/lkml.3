Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKFWhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:37:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKFWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/162] Revert "net/macb: add pinctrl consumer support"
Date: Thu,  6 Nov 2014 14:34:45 -0800
Message-Id: <1415313426-9622-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Soren Brinkmann <soren.brinkmann@xilinx.com>

[ Upstream commit 9026968abe7ad102f4ac5c6d96d733643f75399c ]

This reverts commit 8ef29f8aae524bd51298fb10ac6a5ce6c4c5a3d8.
The driver core already calls pinctrl_get() and claims the default
state. There is no need to replicate this in the driver.
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/cadence/macb.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 9257869..b020d1c 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -29,7 +29,6 @@
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "macb.h"
 
@@ -1755,7 +1754,6 @@ static int __init macb_probe(struct platform_device *pdev)
 	struct phy_device *phydev;
 	u32 config;
 	int err = -ENXIO;
-	struct pinctrl *pinctrl;
 	const char *mac;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1764,15 +1762,6 @@ static int __init macb_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		err = PTR_ERR(pinctrl);
-		if (err == -EPROBE_DEFER)
-			goto err_out;
-
-		dev_warn(&pdev->dev, "No pinctrl provided\n");
-	}
-
 	err = -ENOMEM;
 	dev = alloc_etherdev(sizeof(*bp));
 	if (!dev)
-- 
1.9.1

