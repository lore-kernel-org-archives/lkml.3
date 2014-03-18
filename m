Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaCRCli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:41:38 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:17598 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753593AbaCRClh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:41:37 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux@maxim.org.za>, <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 2/3] ARM: at91: pm_slowclock: add enter standby mode for ARMv7
Date: Tue, 18 Mar 2014 10:33:56 +0800
Message-ID: <1395110037-23151-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395110037-23151-1-git-send-email-wenyou.yang@atmel.com>
References: <1395110037-23151-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/pm_slowclock.S |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 2001877..842ddaf 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -102,6 +102,20 @@ tmp2	.req	r5
 2:
 	.endm
 
+/*
+ * Put the processor to enter into Standby mode, wait for interrupt to wakeup
+ */
+	.macro _do_wfi
+
+#if defined(CONFIG_CPU_V7)
+	dsb
+	wfi		@ Wait For Interrupt
+#else
+	mcr	p15, 0, tmp1, c7, c0, 4
+#endif
+
+	.endm
+
 	.text
 
 /* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc,
@@ -220,7 +234,7 @@ sdr_sr_done:
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
 	/* Wait for interrupt */
-	mcr	p15, 0, tmp1, c7, c0, 4
+	_do_wfi
 
 	/* Turn on the main oscillator */
 	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
-- 
1.7.9.5

