Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3IGJPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:15:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49894 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751183Ab3IGJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:15:50 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: ysato@users.sourceforge.jp, akpm@linux-foundation.org, ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] h8300: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 11:15:45 +0200
Message-Id: <1378545345-8113-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from h8300 architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/h8300/kernel/timer/itu.c     | 2 +-
 arch/h8300/kernel/timer/timer16.c | 2 +-
 arch/h8300/kernel/timer/timer8.c  | 2 +-
 arch/h8300/kernel/timer/tpu.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
index 0a8b5cd..38fd517 100644
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction itu_irq = {
 	.name		= "itu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
index 462d9f58..e77194b 100644
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -54,7 +54,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction timer16_irq = {
 	.name		= "timer-16",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {1, 2, 4, 8};
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 505f341..9219caf 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -74,7 +74,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction timer8_irq = {
 	.name		= "timer-8",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {8, 64, 8192};
diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
index 0350f62..6d83841 100644
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -63,7 +63,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 static struct irqaction tpu_irq = {
 	.name		= "tpu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 };
 
 static const int __initconst divide_rate[] = {
-- 
1.8.1.2

