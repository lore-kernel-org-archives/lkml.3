Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3EPLRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:17:41 -0400
Received: from sauhun.de ([89.238.76.85]:56275 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3EPLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:38 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 30/33] arch/arm/plat-samsung: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:58 +0200
Message-Id: <1368702961-4325-31-git-send-email-wsa@the-dreams.de>
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
 arch/arm/plat-samsung/adc.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index ca07cb1..79690f2 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -381,11 +381,6 @@ static int s3c_adc_probe(struct platform_device *pdev)
 	}
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		dev_err(dev, "failed to find registers\n");
-		return -ENXIO;
-	}
-
 	adc->regs = devm_ioremap_resource(dev, regs);
 	if (IS_ERR(adc->regs))
 		return PTR_ERR(adc->regs);
-- 
1.7.10.4

