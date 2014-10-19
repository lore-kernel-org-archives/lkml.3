Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaJSSEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 14:04:35 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44887 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490AbaJSSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 14:04:33 -0400
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        Stefan Hengelein <stefan.hengelein@fau.de>
Subject: [PATCH] MIPS: MSP71xx: remove compilation error
Date: Sun, 19 Oct 2014 20:04:26 +0200
Message-Id: <1413741866-48496-1-git-send-email-stefan.hengelein@fau.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_MIPS_MT_SMP is enabled, the following compilation error
occurs:

arch/mips/pmcs-msp71xx/msp_irq_cic.c:134: error: ‘irq’ undeclared

This code clearly never saw a compiler.
The surrounding code suggests, that 'd->irq' was intended, not
'irq'.

This error was found with vampyr.

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
---
 arch/mips/pmcs-msp71xx/msp_irq_cic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pmcs-msp71xx/msp_irq_cic.c b/arch/mips/pmcs-msp71xx/msp_irq_cic.c
index b8df2f7..1207ec4 100644
--- a/arch/mips/pmcs-msp71xx/msp_irq_cic.c
+++ b/arch/mips/pmcs-msp71xx/msp_irq_cic.c
@@ -131,11 +131,11 @@ static int msp_cic_irq_set_affinity(struct irq_data *d,
 	int cpu;
 	unsigned long flags;
 	unsigned int  mtflags;
-	unsigned long imask = (1 << (irq - MSP_CIC_INTBASE));
+	unsigned long imask = (1 << (d->irq - MSP_CIC_INTBASE));
 	volatile u32 *cic_mask = (volatile u32 *)CIC_VPE0_MSK_REG;
 
 	/* timer balancing should be disabled in kernel code */
-	BUG_ON(irq == MSP_INT_VPE0_TIMER || irq == MSP_INT_VPE1_TIMER);
+	BUG_ON(d->irq == MSP_INT_VPE0_TIMER || d->irq == MSP_INT_VPE1_TIMER);
 
 	LOCK_CORE(flags, mtflags);
 	/* enable if any of each VPE's TCs require this IRQ */
-- 
1.9.1

