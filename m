Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3FXK5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:57:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:29579 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3FXK5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:57:44 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Bo Shen <voice.shen@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/PMC: fix at91sam9n12 USB FS init
Date: Mon, 24 Jun 2013 12:57:42 +0200
Message-ID: <1372071462-29063-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9n12 has Full-speed only USB. So we should add
it to the list in at91_pllb_usbfs_clock_init() function.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 978de42..2f732d9 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -699,7 +699,7 @@ static void __init at91_pllb_usbfs_clock_init(unsigned long main_clock)
 		at91_pmc_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
 	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() ||
 		   cpu_is_at91sam9263() || cpu_is_at91sam9g20() ||
-		   cpu_is_at91sam9g10()) {
+		   cpu_is_at91sam9g10() || cpu_is_at91sam9n12()) {
 		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
 		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
 	}
-- 
1.8.2.2

