Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbbA0Vsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:48:32 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:47051 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbbA0VqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:46:17 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/9] MIPS: Remove redundant IPTI==IPPCI logic
Date: Tue, 27 Jan 2015 21:45:49 +0000
Message-ID: <1422395155-16511-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
References: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The situation where the timer interrupt is on the same line as the
performance counter interrupt is handled in per_cpu_trap_init() by
setting cp0_perfcount_irq to -1, so there is no need to duplicate the
logic conditional upon cp0_perfcount_irq >= 0 in perf
(init_hw_perf_events()) and oprofile (mipsxx_init()).

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/perf_event_mipsxx.c | 3 +--
 arch/mips/oprofile/op_model_mipsxx.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 9466184d0039..76bc3bb18c45 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1615,8 +1615,7 @@ init_hw_perf_events(void)
 
 	if (get_c0_perfcount_int)
 		irq = get_c0_perfcount_int();
-	else if ((cp0_perfcount_irq >= 0) &&
-		 (cp0_compare_irq != cp0_perfcount_irq))
+	else if (cp0_perfcount_irq >= 0)
 		irq = MIPS_CPU_IRQ_BASE + cp0_perfcount_irq;
 	else
 		irq = -1;
diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index faf0d4ad0cc2..24729f023d93 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -435,8 +435,7 @@ static int __init mipsxx_init(void)
 
 	if (get_c0_perfcount_int)
 		perfcount_irq = get_c0_perfcount_int();
-	else if ((cp0_perfcount_irq >= 0) &&
-		 (cp0_compare_irq != cp0_perfcount_irq))
+	else if (cp0_perfcount_irq >= 0)
 		perfcount_irq = MIPS_CPU_IRQ_BASE + cp0_perfcount_irq;
 	else
 		perfcount_irq = -1;
-- 
2.0.5

