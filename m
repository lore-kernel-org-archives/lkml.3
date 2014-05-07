Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaEGQUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:20:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60708 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932893AbaEGQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:20:52 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
Date: Wed,  7 May 2014 18:20:49 +0200
Message-Id: <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTC IMR register is not reliable on sam9x5 SoCs, hence why me have to
mask all interrupts no matter what IMR claims about already masked irqs.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
---
Hello Bryan,

Yet another patch for you ;-).

As usual, could you tell me if it fixes your bug.

BTW, thanks for your tests.

Best Regards,

Boris

 arch/arm/mach-at91/sysirq_mask.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
index 2ba694f..eb3d2a5 100644
--- a/arch/arm/mach-at91/sysirq_mask.c
+++ b/arch/arm/mach-at91/sysirq_mask.c
@@ -37,12 +37,7 @@ void __init at91_sysirq_mask_rtc(u32 rtc_base)
 	if (!base)
 		return;
 
-	mask = readl_relaxed(base + AT91_RTC_IMR);
-	if (mask) {
-		pr_info("AT91: Disabling rtc irq\n");
-		writel_relaxed(mask, base + AT91_RTC_IDR);
-		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
-	}
+	writel_relaxed(0x1f, base + AT91_RTC_IDR);
 
 	iounmap(base);
 }
-- 
1.8.3.2

