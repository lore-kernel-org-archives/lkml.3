Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaIOXwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:09 -0400
Received: from mail-yk0-f201.google.com ([209.85.160.201]:44843 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbaIOXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:38 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/24] MIPS: Set vint handler when mapping CPU interrupts
Date: Mon, 15 Sep 2014 16:51:07 -0700
Message-Id: <1410825087-5497-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mapping an interrupt in the CPU IRQ domain, set the vint handler
for that interrupt if the CPU uses vectored interrupt handling.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/kernel/irq_cpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index f17bd08..5069acb 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -36,6 +36,7 @@
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
+#include <asm/setup.h>
 
 static inline void unmask_mips_irq(struct irq_data *d)
 {
@@ -121,6 +122,9 @@ static int mips_cpu_intc_map(struct irq_domain *d, unsigned int irq,
 		chip = &mips_cpu_irq_controller;
 	}
 
+	if (cpu_has_vint)
+		set_vi_handler(hw, plat_irq_dispatch);
+
 	irq_set_chip_and_handler(irq, chip, handle_percpu_irq);
 
 	return 0;
-- 
2.1.0.rc2.206.gedb03e5

