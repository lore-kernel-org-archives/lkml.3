Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaEHIMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:12:38 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50178 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaEHIJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:09:58 -0400
From: Johan Hovold <jhovold@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mugunthan V N <mugunthanvnm@ti.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH RESEND 2/5] net: mdio-gpio: warn about missing bus alias id
Date: Thu,  8 May 2014 10:09:21 +0200
Message-Id: <1399536564-7626-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399536564-7626-1-git-send-email-jhovold@gmail.com>
References: <1399534639-4947-1-git-send-email-jhovold@gmail.com>
 <1399536564-7626-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a sane default bus id (rather than -ENODEV) and print a warning when
the bus alias id is missing.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/net/phy/mdio-gpio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index 9c4defdec67b..5f1a2250018f 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -215,6 +215,10 @@ static int mdio_gpio_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node) {
 		pdata = mdio_gpio_of_get_data(pdev);
 		bus_id = of_alias_get_id(pdev->dev.of_node, "mdio-gpio");
+		if (bus_id < 0) {
+			dev_warn(&pdev->dev, "failed to get alias id\n");
+			bus_id = 0;
+		}
 	} else {
 		pdata = dev_get_platdata(&pdev->dev);
 		bus_id = pdev->id;
-- 
1.8.3.2

