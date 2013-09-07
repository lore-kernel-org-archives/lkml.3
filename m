Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936Ab3IGGgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 02:36:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49688 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821Ab3IGGgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 02:36:18 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, venki@google.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] x86: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 08:36:12 +0200
Message-Id: <1378535772-6897-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from x86 architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

x86/xen support code will be addressed in a separate patch.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/x86/include/asm/floppy.h | 4 ++--
 arch/x86/kernel/hpet.c        | 2 +-
 arch/x86/kernel/time.c        | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/floppy.h b/arch/x86/include/asm/floppy.h
index d3d7469..1c7eefe 100644
--- a/arch/x86/include/asm/floppy.h
+++ b/arch/x86/include/asm/floppy.h
@@ -145,10 +145,10 @@ static int fd_request_irq(void)
 {
 	if (can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static unsigned long dma_mem_alloc(unsigned long size)
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..45d2ded 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -521,7 +521,7 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
+			IRQF_TIMER | IRQF_NOBALANCING,
 			dev->name, dev))
 		return -1;
 
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 24d3c91..36b2cee 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -62,7 +62,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.flags = IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
 	.name = "timer"
 };
 
-- 
1.8.1.2

