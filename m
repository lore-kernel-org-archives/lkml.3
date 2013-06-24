Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3FXQi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:38:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:45709 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3FXQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:38:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Bo Shen <voice.shen@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] ARM: at91/PMC: use at91_usb_rate() for UTMI PLL
Date: Mon, 24 Jun 2013 18:38:54 +0200
Message-ID: <1372091934-28512-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using this function, now that we have introduced
the support for UTMI clock for computing the USB host rate.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 661111f..6b2630a 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -742,8 +742,7 @@ static void __init at91_upll_usbfs_clock_init(unsigned long main_clock)
 	/* Now set uhpck values */
 	uhpck.parent = &utmi_clk;
 	uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
-	uhpck.rate_hz = utmi_clk.rate_hz;
-	uhpck.rate_hz /= 1 + ((at91_pmc_read(AT91_PMC_USB) & AT91_PMC_OHCIUSBDIV) >> 8);
+	uhpck.rate_hz = at91_usb_rate(&utmi_clk, utmi_clk.rate_hz, usbr);
 }
 
 static int __init at91_pmc_init(unsigned long main_clock)
-- 
1.8.2.2

