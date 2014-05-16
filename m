Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbaEPNg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:36:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaEPNgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:36:53 -0400
Date: Fri, 16 May 2014 06:36:02 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-18a67d32c31b88679467e93e1825010d245b9bf4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154338.967285614@linutronix.de>
References: <20140507154338.967285614@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86, irq: Remove pointless irq_reserve_irqs() call
Git-Commit-ID: 18a67d32c31b88679467e93e1825010d245b9bf4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18a67d32c31b88679467e93e1825010d245b9bf4
Gitweb:     http://git.kernel.org/tip/18a67d32c31b88679467e93e1825010d245b9bf4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:18 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:21 +0200

x86, irq: Remove pointless irq_reserve_irqs() call

That's a leftover from the time where x86 supported SPARSE_IRQ=n.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140507154338.967285614@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index efda2f6..9d0a979 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -206,9 +206,6 @@ int __init arch_early_irq_init(void)
 	count = ARRAY_SIZE(irq_cfgx);
 	node = cpu_to_node(0);
 
-	/* Make sure the legacy interrupts are marked in the bitmap */
-	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
-
 	for (i = 0; i < count; i++) {
 		irq_set_chip_data(i, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
