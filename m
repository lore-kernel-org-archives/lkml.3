Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaCDUwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:52:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274AbaCDUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:52:08 -0500
Date: Tue, 4 Mar 2014 12:51:56 -0800
From: tip-bot for Michael Opdenacker <tipbot@zytor.com>
Message-ID: <tip-d20d2efbf227042920d386b8eda878815f63c987@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        michael.opdenacker@free-electrons.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        michael.opdenacker@free-electrons.com, tglx@linutronix.de
In-Reply-To: <1393965305-17248-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1393965305-17248-1-git-send-email-michael.opdenacker@free-electrons.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Remove deprecated IRQF_DISABLED
Git-Commit-ID: d20d2efbf227042920d386b8eda878815f63c987
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d20d2efbf227042920d386b8eda878815f63c987
Gitweb:     http://git.kernel.org/tip/d20d2efbf227042920d386b8eda878815f63c987
Author:     Michael Opdenacker <michael.opdenacker@free-electrons.com>
AuthorDate: Tue, 4 Mar 2014 21:35:05 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 21:47:51 +0100

x86: Remove deprecated IRQF_DISABLED

This patch removes the IRQF_DISABLED flag from x86 architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: venki@google.com
Link: http://lkml.kernel.org/r/1393965305-17248-1-git-send-email-michael.opdenacker@free-electrons.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
