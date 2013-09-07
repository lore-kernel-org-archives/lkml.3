Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005Ab3IGHHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 03:07:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49734 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875Ab3IGHHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 03:07:17 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: nsekhar@ti.com, khilman@deeprootsystems.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: davinci: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 09:07:13 +0200
Message-Id: <1378537633-7232-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from Davinci code ;)
It's a NOOP since 2.6.35, and will be removed one day

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-davinci/board-da830-evm.c     | 2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c | 2 +-
 arch/arm/mach-davinci/time.c                | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 1332de8..3aeae57 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -74,7 +74,7 @@ static int da830_evm_usb_ocic_notify(da8xx_ocic_handler_t handler)
 	if (handler != NULL) {
 		da830_evm_usb_ocic_handler = handler;
 
-		error = request_irq(irq, da830_evm_usb_ocic_irq, IRQF_DISABLED |
+		error = request_irq(irq, da830_evm_usb_ocic_irq,
 				    IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				    "OHCI over-current indicator", NULL);
 		if (error)
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index b8c20de..b635012 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -211,7 +211,7 @@ static int hawk_usb_ocic_notify(da8xx_ocic_handler_t handler)
 		hawk_usb_ocic_handler = handler;
 
 		error = request_irq(irq, omapl138_hawk_usb_ocic_irq,
-					IRQF_DISABLED | IRQF_TRIGGER_RISING |
+					IRQF_TRIGGER_RISING |
 					IRQF_TRIGGER_FALLING,
 					"OHCI over-current indicator", NULL);
 		if (error)
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index 7a55b5c..e7ada0c 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -181,7 +181,7 @@ static struct timer_s timers[] = {
 		.name      = "clockevent",
 		.opts      = TIMER_OPTS_DISABLED,
 		.irqaction = {
-			.flags   = IRQF_DISABLED | IRQF_TIMER,
+			.flags   = IRQF_TIMER,
 			.handler = timer_interrupt,
 		}
 	},
@@ -190,7 +190,7 @@ static struct timer_s timers[] = {
 		.period     = ~0,
 		.opts       = TIMER_OPTS_PERIODIC,
 		.irqaction = {
-			.flags   = IRQF_DISABLED | IRQF_TIMER,
+			.flags   = IRQF_TIMER,
 			.handler = freerun_interrupt,
 		}
 	},
-- 
1.8.1.2

