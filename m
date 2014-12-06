Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaLFWlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:41:45 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39664 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaLFWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:41:44 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Vineet Gupta <vgupta@synopsys.com>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] arch: arc: plat-arcfpga: smp.c:  Remove some unused functions
Date: Sat,  6 Dec 2014 23:44:23 +0100
Message-Id: <1417905863-5310-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
idu_irq_get_pend() idu_irq_get_ack()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arc/plat-arcfpga/smp.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/arch/arc/plat-arcfpga/smp.c b/arch/arc/plat-arcfpga/smp.c
index 64797ba..2b1b42a 100644
--- a/arch/arc/plat-arcfpga/smp.c
+++ b/arch/arc/plat-arcfpga/smp.c
@@ -157,30 +157,3 @@ void idu_irq_set_tgtcpu(uint8_t irq, uint32_t mask)
 	IDU_SET_PARAM(mask);
 	IDU_SET_COMMAND(irq, IDU_IRQ_WBITMASK);
 }
-
-/* Get the Interrupt Acknowledged status for IRQ (as CPU Bitmask) */
-bool idu_irq_get_ack(uint8_t irq)
-{
-	uint32_t val;
-
-	IDU_SET_COMMAND(irq, IDU_IRQ_ACK);
-	val = IDU_GET_PARAM();
-
-	return val & (1 << irq);
-}
-
-/*
- * Get the Interrupt Pending status for IRQ (as CPU Bitmask)
- * -Pending means CPU has not yet noticed the IRQ (e.g. disabled)
- * -After Interrupt has been taken, the IPI expcitily needs to be
- *  cleared, to be acknowledged.
- */
-bool idu_irq_get_pend(uint8_t irq)
-{
-	uint32_t val;
-
-	IDU_SET_COMMAND(irq, IDU_IRQ_PEND);
-	val = IDU_GET_PARAM();
-
-	return val & (1 << irq);
-}
-- 
1.7.10.4

