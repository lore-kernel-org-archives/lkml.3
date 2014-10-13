Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaJMC2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:28:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaJMC2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:28:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 33/55] Revert "net/macb: add pinctrl consumer support"
Date: Mon, 13 Oct 2014 04:24:47 +0200
Message-Id: <20141013022445.192422510@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Soren Brinkmann <soren.brinkmann@xilinx.com>

[ Upstream commit 9026968abe7ad102f4ac5c6d96d733643f75399c ]

This reverts commit 8ef29f8aae524bd51298fb10ac6a5ce6c4c5a3d8.
The driver core already calls pinctrl_get() and claims the default
state. There is no need to replicate this in the driver.
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -30,7 +30,6 @@
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "macb.h"
 
@@ -1803,7 +1802,6 @@ static int __init macb_probe(struct plat
 	struct phy_device *phydev;
 	u32 config;
 	int err = -ENXIO;
-	struct pinctrl *pinctrl;
 	const char *mac;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1812,15 +1810,6 @@ static int __init macb_probe(struct plat
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


