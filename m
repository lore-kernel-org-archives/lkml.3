Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaJTS1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:27:22 -0400
Received: from down.free-electrons.com ([37.187.137.238]:51860 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500AbaJTS1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:27:20 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] power: reset: at91-reset: fix power down register
Date: Mon, 20 Oct 2014 20:27:09 +0200
Message-Id: <1413829629-8705-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of at91sam9g45_restart(), the driver is writing
AT91_DDRSDRC_LPCB_POWER_DOWN to AT91_DDRSDRC_RTR, this should actually be
AT91_DDRSDRC_LPR.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/power/reset/at91-reset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
index 3611806c9cfd..3cb36693343a 100644
--- a/drivers/power/reset/at91-reset.c
+++ b/drivers/power/reset/at91-reset.c
@@ -100,11 +100,11 @@ static void at91sam9g45_restart(enum reboot_mode mode, const char *cmd)
 		/* Disable SDRAM0 accesses */
 		"1:	str	%3, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
 		/* Power down SDRAM0 */
-		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
 		/* Disable SDRAM1 accesses */
 		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
 		/* Power down SDRAM1 */
-		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_LPR) "]\n\t"
 		/* Reset CPU */
 		"	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
 
-- 
1.9.1

