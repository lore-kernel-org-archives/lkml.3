Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbbA0VqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:46:18 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:1755 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbbA0VqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:46:17 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/9] MIPS: Use CAUSEF_TI, CAUSEF_PCI constants
Date: Tue, 27 Jan 2015 21:45:48 +0000
Message-ID: <1422395155-16511-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
References: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CAUSEF_TI and CAUSEF_PCI constants from asm/mipsregs.h rather than
the magic values (1 << 30) and (1 << 26).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/cevt-r4k.c          | 2 +-
 arch/mips/oprofile/op_model_mipsxx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 02dd77955a6f..d68a678b7e4e 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -76,7 +76,7 @@ irqreturn_t c0_compare_interrupt(int irq, void *dev_id)
 	 * above we now know that the reason we got here must be a timer
 	 * interrupt.  Being the paranoiacs we are we check anyway.
 	 */
-	if (!r2 || (read_c0_cause() & (1 << 30))) {
+	if (!r2 || (read_c0_cause() & CAUSEF_TI)) {
 		/* Clear Count/Compare Interrupt */
 		write_c0_compare(read_c0_compare());
 		cd = &per_cpu(mips_clockevent_device, cpu);
diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index 01f721a85c5b..faf0d4ad0cc2 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -246,7 +246,7 @@ static int mipsxx_perfcount_handler(void)
 	unsigned int counter;
 	int handled = IRQ_NONE;
 
-	if (cpu_has_mips_r2 && !(read_c0_cause() & (1 << 26)))
+	if (cpu_has_mips_r2 && !(read_c0_cause() & CAUSEF_PCI))
 		return handled;
 
 	switch (counters) {
-- 
2.0.5

