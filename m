Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab3EBMKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:10:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab3EBMKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:10:04 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH 5/5] drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request fails
Date: Thu, 2 May 2013 14:09:47 +0200
Message-ID: <1367496587-6210-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367496587-6210-1-git-send-email-peter.ujfalusi@ti.com>
References: <1367496587-6210-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_err() which will going to print the driver's name as well and the
KERN_ERR level is sufficient in this case (we also print via dev_err when
there is an error with the mem resources)

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/bus/omap_l3_noc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index ed428ad..3a36e3e 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -162,8 +162,8 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, l3->debug_irq, l3_interrupt_handler,
 			       IRQF_DISABLED, "l3-dbg-irq", l3);
 	if (ret) {
-		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						l3->debug_irq);
+		dev_err(&pdev->dev, "request_irq failed for %d\n",
+			l3->debug_irq);
 		return ret;
 	}
 
@@ -171,8 +171,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, l3->app_irq, l3_interrupt_handler,
 			       IRQF_DISABLED, "l3-app-irq", l3);
 	if (ret)
-		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						l3->app_irq);
+		dev_err(&pdev->dev, "request_irq failed for %d\n", l3->app_irq);
 
 	return ret;
 }
-- 
1.8.2.1

