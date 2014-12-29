Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaL2Xe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:34:57 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41130 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaL2Xc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:27 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 06/12] ARM: unify MMU/!MMU addruart calls
Date: Tue, 30 Dec 2014 00:32:09 +0100
Message-Id: <1419895935-22966-7-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the needless differences between MMU/!MMU addruart calls.
This allows to use the same addruart macro on SoC level. Useful
for SoC consisting of multiple CPUs with and without MMU such as
Freescale Vybrid.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/include/debug/efm32.S | 2 +-
 arch/arm/kernel/debug.S        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/debug/efm32.S b/arch/arm/include/debug/efm32.S
index 2265a19..660fa1e 100644
--- a/arch/arm/include/debug/efm32.S
+++ b/arch/arm/include/debug/efm32.S
@@ -16,7 +16,7 @@
 
 #define	UARTn_TXDATA		0x0034
 
-		.macro	addruart, rx, tmp
+		.macro	addruart, rx, tmp, tmp2
 		ldr	\rx, =(CONFIG_DEBUG_UART_PHYS)
 
 		/*
diff --git a/arch/arm/kernel/debug.S b/arch/arm/kernel/debug.S
index 78c91b5..ea9646c 100644
--- a/arch/arm/kernel/debug.S
+++ b/arch/arm/kernel/debug.S
@@ -35,7 +35,7 @@
 
 #else /* !CONFIG_MMU */
 		.macro	addruart_current, rx, tmp1, tmp2
-		addruart	\rx, \tmp1
+		addruart	\rx, \tmp1, \tmp2
 		.endm
 
 #endif /* CONFIG_MMU */
-- 
2.2.1

