Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaH2WR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:17:28 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:65158 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaH2WOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:48 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] MIPS: Set vint handler when mapping CPU interrupts
Date: Fri, 29 Aug 2014 15:14:29 -0700
Message-Id: <1409350479-19108-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
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
index 9cf8459..33a4385 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -36,6 +36,7 @@
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
+#include <asm/setup.h>
 
 static inline void unmask_mips_irq(struct irq_data *d)
 {
@@ -146,6 +147,9 @@ static int mips_cpu_intc_map(struct irq_domain *d, unsigned int irq,
 		chip = &mips_cpu_irq_controller;
 	}
 
+	if (cpu_has_vint)
+		set_vi_handler(hw, plat_irq_dispatch);
+
 	irq_set_chip_and_handler(irq, chip, handle_percpu_irq);
 
 	return 0;
-- 
2.1.0.rc2.206.gedb03e5

