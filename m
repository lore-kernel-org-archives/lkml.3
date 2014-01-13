Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaAMNkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:40:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaAMNku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:40:50 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] x86, irq Fix kbuild warning in smp_irq_move_cleanup_interrupt()
Date: Mon, 13 Jan 2014 08:40:20 -0500
Message-Id: <1389620420-7110-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild, 0day kernel build service, outputs the warning:

arch/x86/kernel/apic/io_apic.c:2211 smp_irq_move_cleanup_interrupt() warn:
always true condition '(irq <= -1) => (0-u32max <= (-1))'

because irq is defined as an unsigned int instead of an int.  Fix this
trivial error by redefining irq as a signed int.  The remaining consumers of the
int are okay.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e63a5bd..c4db751 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2202,7 +2202,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		unsigned int irq;
+		int irq;
 		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
-- 
1.7.9.3

