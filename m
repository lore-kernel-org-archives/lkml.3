Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbbANQZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:25:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45284 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753898AbbANQWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:22:19 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 05/12] usb: gadget: at91_udc: Fix clock names
Date: Wed, 14 Jan 2015 17:21:57 +0100
Message-Id: <1421252524-24452-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

The driver is requesting clock by their global name (those declared in the
clk_lookup list), but this only works with !CCF kernels.

Now that all SoCs have moved to CCF, fix the driver to use local names
(hclk and pclk).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/usb/gadget/udc/at91_udc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index c862656d18b8..9ff2f7e5c6a7 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1779,8 +1779,8 @@ static int at91udc_probe(struct platform_device *pdev)
 	udc_reinit(udc);
 
 	/* get interface and function clocks */
-	udc->iclk = clk_get(dev, "udc_clk");
-	udc->fclk = clk_get(dev, "udpck");
+	udc->iclk = clk_get(dev, "pclk");
+	udc->fclk = clk_get(dev, "hclk");
 	if (IS_ENABLED(CONFIG_COMMON_CLK))
 		udc->uclk = clk_get(dev, "usb_clk");
 	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk) ||
-- 
2.1.0

