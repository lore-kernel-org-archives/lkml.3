Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbbAZJmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:42:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:46906 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbbAZJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:42:04 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH v2 03/12] pm: at91: pm_slowclock: remove the unused code related with SLOWDOWN_MASTER_CLOCK
Date: Mon, 26 Jan 2015 17:39:40 +0800
Message-ID: <1422265180-23077-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SLOWDOWN_MASTER_CLOCK definition is not used, remove the redundant code.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm_slowclock.S |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 1155217..4e55665 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -11,20 +11,11 @@
  * published by the Free Software Foundation.
  *
  */
-
 #include <linux/linkage.h>
 #include <linux/clk/at91_pmc.h>
 #include <mach/hardware.h>
 #include <mach/at91_ramc.h>
 
-/*
- * When SLOWDOWN_MASTER_CLOCK is defined we will also slow down the Master
- * clock during suspend by adjusting its prescalar and divisor.
- * NOTE: This hasn't been shown to be stable on SAM9s; and on the RM9200 there
- *       are errata regarding adjusting the prescalar and divisor.
- */
-#undef SLOWDOWN_MASTER_CLOCK
-
 pmc	.req	r0
 sdramc	.req	r1
 ramc1	.req	r2
@@ -166,18 +157,6 @@ sdr_sr_done:
 
 	wait_mckrdy
 
-#ifdef SLOWDOWN_MASTER_CLOCK
-	/*
-	 * Set the Master Clock PRES and MDIV fields.
-	 *
-	 * See AT91RM9200 errata #27 and #28 for details.
-	 */
-	mov	tmp1, #0
-	str	tmp1, [pmc, #AT91_PMC_MCKR]
-
-	wait_mckrdy
-#endif
-
 	/* Save PLLA setting and disable it */
 	ldr	tmp1, [pmc, #AT91_CKGR_PLLAR]
 	str	tmp1, .saved_pllar
@@ -213,22 +192,6 @@ sdr_sr_done:
 	wait_pllalock
 4:
 
-#ifdef SLOWDOWN_MASTER_CLOCK
-	/*
-	 * First set PRES if it was not 0,
-	 * than set CSS and MDIV fields.
-	 *
-	 * See AT91RM9200 errata #27 and #28 for details.
-	 */
-	ldr	tmp1, .saved_mckr
-	tst	tmp1, #AT91_PMC_PRES
-	beq	2f
-	and	tmp1, tmp1, #AT91_PMC_PRES
-	str	tmp1, [pmc, #AT91_PMC_MCKR]
-
-	wait_mckrdy
-#endif
-
 	/*
 	 * Restore master clock setting
 	 */
-- 
1.7.9.5

