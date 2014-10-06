Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaJFPhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:37:00 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:18856 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbaJFPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:36:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvENAEC2MlRXQzrG/2dsb2JhbABfgw6BK7gQAQUBc5pnAoEDFwF7hAQBBScvIxBROR4ZiEIBsluONxiGIIolBxaENQWdPoxSiS6DZTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 7/7 linux-next] bus: omap_l3_smx: remove deprecated IRQF_DISABLED
Date: Mon,  6 Oct 2014 17:35:54 +0200
Message-Id: <1412609755-28627-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412609755-28627-1-git-send-email-fabf@skynet.be>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See include/linux/interrupt.h:
"This flag is a NOOP and scheduled to be removed"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/bus/omap_l3_smx.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
index acc2164..9ae0997 100644
--- a/drivers/bus/omap_l3_smx.c
+++ b/drivers/bus/omap_l3_smx.c
@@ -237,18 +237,16 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 	}
 
 	l3->debug_irq = platform_get_irq(pdev, 0);
-	ret = request_irq(l3->debug_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
-		"l3-debug-irq", l3);
+	ret = request_irq(l3->debug_irq, omap3_l3_app_irq, IRQF_TRIGGER_RISING,
+			  "l3-debug-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request debug irq\n");
 		goto err1;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
-	ret = request_irq(l3->app_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
-		"l3-app-irq", l3);
+	ret = request_irq(l3->app_irq, omap3_l3_app_irq, IRQF_TRIGGER_RISING,
+			  "l3-app-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request app irq\n");
 		goto err2;
-- 
1.9.3

