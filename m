Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888Ab3IGGVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 02:21:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49659 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804Ab3IGGVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 02:21:02 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH-v2] frv: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 08:20:58 +0200
Message-Id: <1378534858-6700-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from FRV architecture
code. It's a NOOP since 2.6.35 and it will be removed one day.

This second version of the patch removes unless structure
member initializations (.flags = 0)

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/frv/kernel/irq-mb93091.c | 8 ++++----
 arch/frv/kernel/irq-mb93093.c | 1 -
 arch/frv/kernel/irq-mb93493.c | 4 ++--
 arch/frv/kernel/time.c        | 1 -
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/frv/kernel/irq-mb93091.c b/arch/frv/kernel/irq-mb93091.c
index 2cc327a..091b283 100644
--- a/arch/frv/kernel/irq-mb93091.c
+++ b/arch/frv/kernel/irq-mb93091.c
@@ -107,25 +107,25 @@ static irqreturn_t fpga_interrupt(int irq, void *_mask)
 static struct irqaction fpga_irq[4]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0028UL,
 	},
 	[1] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.1",
 		.dev_id		= (void *) 0x0050UL,
 	},
 	[2] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.2",
 		.dev_id		= (void *) 0x1c00UL,
 	},
 	[3] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "fpga.3",
 		.dev_id		= (void *) 0x6386UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93093.c b/arch/frv/kernel/irq-mb93093.c
index 95e4eb4..1f3015c 100644
--- a/arch/frv/kernel/irq-mb93093.c
+++ b/arch/frv/kernel/irq-mb93093.c
@@ -105,7 +105,6 @@ static irqreturn_t fpga_interrupt(int irq, void *_mask)
 static struct irqaction fpga_irq[1]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0700UL,
 	}
diff --git a/arch/frv/kernel/irq-mb93493.c b/arch/frv/kernel/irq-mb93493.c
index ba648da..8ca5aa4 100644
--- a/arch/frv/kernel/irq-mb93493.c
+++ b/arch/frv/kernel/irq-mb93493.c
@@ -118,13 +118,13 @@ static irqreturn_t mb93493_interrupt(int irq, void *_piqsr)
 static struct irqaction mb93493_irq[2]  = {
 	[0] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "mb93493.0",
 		.dev_id		= (void *) __addr_MB93493_IQSR(0),
 	},
 	[1] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		= IRQF_SHARED,
 		.name		= "mb93493.1",
 		.dev_id		= (void *) __addr_MB93493_IQSR(1),
 	}
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index b457de4..332e00b 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -44,7 +44,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy);
 
 static struct irqaction timer_irq  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "timer",
 };
 
-- 
1.8.1.2

