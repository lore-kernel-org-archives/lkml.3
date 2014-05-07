Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524AbaEGPKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:10:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44597 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbaEGPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:10:29 -0400
X-Sasl-enc: liZrdUF3lEVupVRyCevw6W4Aw2142x2PIAiwbODbhNdl 1399475426
From: Juan Solano <jsm@jsolano.com>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Juan Solano <jsm@jsolano.com>
Subject: [PATCH] ARM: i.MX27 pca100: remove deprecated IRQF_DISABLED
Date: Wed,  7 May 2014 17:09:59 +0200
Message-Id: <1399475399-8770-1-git-send-email-jsm@jsolano.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and can be removed now.

Signed-off-by: Juan Solano <jsm@jsolano.com>
---
 arch/arm/mach-imx/mach-pca100.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index bf3ac51..20e7c33 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -245,8 +245,7 @@ static int pca100_sdhc2_init(struct device *dev, irq_handler_t detect_irq,
 	int ret;
 
 	ret = request_irq(gpio_to_irq(IMX_GPIO_NR(3, 29)), detect_irq,
-			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
-			  "imx-mmc-detect", data);
+			  IRQF_TRIGGER_FALLING, "imx-mmc-detect", data);
 	if (ret)
 		printk(KERN_ERR
 			"pca100: Failed to request irq for sd/mmc detection\n");
-- 
1.7.9.5

