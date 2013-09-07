Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931Ab3IGFnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 01:43:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49609 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844Ab3IGFnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 01:43:23 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: geert@linux-m68k.org, sammy@sammy.net
Cc: ljalvs@gmail.com, gerg@uclinux.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] m68k: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 07:43:08 +0200
Message-Id: <1378532588-6054-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from m68k architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/m68k/include/asm/floppy.h         | 2 +-
 arch/m68k/include/asm/sun3xflop.h      | 2 +-
 arch/m68k/platform/68000/timers.c      | 2 +-
 arch/m68k/platform/68360/config.c      | 2 +-
 arch/m68k/platform/coldfire/pit.c      | 2 +-
 arch/m68k/platform/coldfire/sltimers.c | 4 ++--
 arch/m68k/platform/coldfire/timers.c   | 4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/include/asm/floppy.h b/arch/m68k/include/asm/floppy.h
index 697d503..47365b1 100644
--- a/arch/m68k/include/asm/floppy.h
+++ b/arch/m68k/include/asm/floppy.h
@@ -85,7 +85,7 @@ static int fd_request_irq(void)
 {
 	if(MACH_IS_Q40)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", floppy_hardint);
+				   0, "floppy", floppy_hardint);
 	else if(MACH_IS_SUN3X)
 		return sun3xflop_request_irq();
 	return -ENXIO;
diff --git a/arch/m68k/include/asm/sun3xflop.h b/arch/m68k/include/asm/sun3xflop.h
index 95231e2..a02ea3a 100644
--- a/arch/m68k/include/asm/sun3xflop.h
+++ b/arch/m68k/include/asm/sun3xflop.h
@@ -207,7 +207,7 @@ static int sun3xflop_request_irq(void)
 	if(!once) {
 		once = 1;
 		error = request_irq(FLOPPY_IRQ, sun3xflop_hardint,
-				    IRQF_DISABLED, "floppy", NULL);
+				    0, "floppy", NULL);
 		return ((error == 0) ? 0 : -1);
 	} else return 0;
 }
diff --git a/arch/m68k/platform/68000/timers.c b/arch/m68k/platform/68000/timers.c
index ec30acb..99a9869 100644
--- a/arch/m68k/platform/68000/timers.c
+++ b/arch/m68k/platform/68000/timers.c
@@ -70,7 +70,7 @@ static irqreturn_t hw_tick(int irq, void *dummy)
 
 static struct irqaction m68328_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = hw_tick,
 };
 
diff --git a/arch/m68k/platform/68360/config.c b/arch/m68k/platform/68360/config.c
index 9877cef..fae263e 100644
--- a/arch/m68k/platform/68360/config.c
+++ b/arch/m68k/platform/68360/config.c
@@ -58,7 +58,7 @@ static irqreturn_t hw_tick(int irq, void *dummy)
 
 static struct irqaction m68360_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = hw_tick,
 };
 
diff --git a/arch/m68k/platform/coldfire/pit.c b/arch/m68k/platform/coldfire/pit.c
index e8f3b97..493b311 100644
--- a/arch/m68k/platform/coldfire/pit.c
+++ b/arch/m68k/platform/coldfire/pit.c
@@ -118,7 +118,7 @@ static irqreturn_t pit_tick(int irq, void *dummy)
 
 static struct irqaction pit_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = pit_tick,
 };
 
diff --git a/arch/m68k/platform/coldfire/sltimers.c b/arch/m68k/platform/coldfire/sltimers.c
index bb5a25a..831a08c 100644
--- a/arch/m68k/platform/coldfire/sltimers.c
+++ b/arch/m68k/platform/coldfire/sltimers.c
@@ -51,7 +51,7 @@ irqreturn_t mcfslt_profile_tick(int irq, void *dummy)
 
 static struct irqaction mcfslt_profile_irq = {
 	.name	 = "profile timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = mcfslt_profile_tick,
 };
 
@@ -93,7 +93,7 @@ static irqreturn_t mcfslt_tick(int irq, void *dummy)
 
 static struct irqaction mcfslt_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = mcfslt_tick,
 };
 
diff --git a/arch/m68k/platform/coldfire/timers.c b/arch/m68k/platform/coldfire/timers.c
index d06068e..cd496a2 100644
--- a/arch/m68k/platform/coldfire/timers.c
+++ b/arch/m68k/platform/coldfire/timers.c
@@ -83,7 +83,7 @@ static irqreturn_t mcftmr_tick(int irq, void *dummy)
 
 static struct irqaction mcftmr_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = mcftmr_tick,
 };
 
@@ -171,7 +171,7 @@ irqreturn_t coldfire_profile_tick(int irq, void *dummy)
 
 static struct irqaction coldfire_profile_irq = {
 	.name	 = "profile timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 = IRQF_TIMER,
 	.handler = coldfire_profile_tick,
 };
 
-- 
1.8.1.2

