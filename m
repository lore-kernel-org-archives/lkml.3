Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbbAOO7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:59:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54356 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752725AbbAOO7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:59:37 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 3/8] ARM: at91: pm: add UDP and UHP checks to newer SoCs
Date: Thu, 15 Jan 2015 15:59:26 +0100
Message-Id: <1421333971-7581-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check UDP and UHP on sam9x5, sam9n12 and the sama5 series.
Check UHP on the sam9g45.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 515791edcc60..71cc845263dc 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -275,6 +275,7 @@ static int __init at91_pm_init(void)
 	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));
 
 	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
+	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
 
 	if (of_machine_is_compatible("atmel,at91rm9200")) {
 		/*
@@ -286,14 +287,8 @@ static int __init at91_pm_init(void)
 		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP |
 					    AT91RM9200_PMC_UDP;
 		at91_pm_data.memctrl = AT91_MEMCTRL_MC;
-	} else if (of_machine_is_compatible("atmel,at91sam9260") ||
-		   of_machine_is_compatible("atmel,at91sam9g20") ||
-		   of_machine_is_compatible("atmel,at91sam9261") ||
-		   of_machine_is_compatible("atmel,at91sam9g10") ||
-		   of_machine_is_compatible("atmel,at91sam9263")) {
-		at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP |
-					    AT91SAM926x_PMC_UDP;
 	} else if (of_machine_is_compatible("atmel,at91sam9g45")) {
+		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP;
 		at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
 	}
 
-- 
2.1.0

