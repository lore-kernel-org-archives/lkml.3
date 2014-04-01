Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaDANYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:24:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55376 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaDANYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:24:30 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <arnd@arndb.de>,
        <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 5/5] drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request fails
Date: Tue, 1 Apr 2014 16:23:50 +0300
Message-ID: <1396358630-32340-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396358630-32340-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396358630-32340-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_err() which will going to print the driver's name as well and the
KERN_ERR level is sufficient in this case (we also print via dev_err when
there is an error with the mem resources)

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/bus/omap_l3_noc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 0eff48585ae3..972691a668a3 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -158,8 +158,8 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, l3->debug_irq, l3_interrupt_handler,
 			       IRQF_DISABLED, "l3-dbg-irq", l3);
 	if (ret) {
-		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						l3->debug_irq);
+		dev_err(&pdev->dev, "request_irq failed for %d\n",
+			l3->debug_irq);
 		return ret;
 	}
 
@@ -167,8 +167,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, l3->app_irq, l3_interrupt_handler,
 			       IRQF_DISABLED, "l3-app-irq", l3);
 	if (ret)
-		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						l3->app_irq);
+		dev_err(&pdev->dev, "request_irq failed for %d\n", l3->app_irq);
 
 	return ret;
 }
-- 
1.9.1

