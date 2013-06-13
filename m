Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3FMMV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:21:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31965 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3FMMV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:27 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/10] metag: log core and timer frequencies from arch code
Date: Thu, 13 Jun 2013 13:19:33 +0100
Message-ID: <1371125981-5184-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
References: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log core clock and Meta timer frequencies during init in architecture
generic code, removing the need for equivalent log messages in SoC
specific code.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/metag/kernel/clock.c           | 2 ++
 drivers/clocksource/metag_generic.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/metag/kernel/clock.c b/arch/metag/kernel/clock.c
index 8bfd6a5..6339c9c 100644
--- a/arch/metag/kernel/clock.c
+++ b/arch/metag/kernel/clock.c
@@ -87,6 +87,8 @@ static void __init init_metag_core_clock(void)
 void __init init_metag_clocks(void)
 {
 	init_metag_core_clock();
+
+	pr_info("Core clock frequency: %lu Hz\n", get_coreclock());
 }
 
 /**
diff --git a/drivers/clocksource/metag_generic.c b/drivers/clocksource/metag_generic.c
index ade7513..6722f0e 100644
--- a/drivers/clocksource/metag_generic.c
+++ b/drivers/clocksource/metag_generic.c
@@ -184,6 +184,8 @@ int __init metag_generic_timer_init(void)
 #ifdef CONFIG_METAG_META21
 	hwtimer_freq = get_coreclock() / (metag_in32(EXPAND_TIMER_DIV) + 1);
 #endif
+	pr_info("Timer frequency: %u Hz\n", hwtimer_freq);
+
 	clocksource_register_hz(&clocksource_metag, hwtimer_freq);
 
 	setup_irq(tbisig_map(TBID_SIGNUM_TRT), &metag_timer_irq);
-- 
1.8.1.2


