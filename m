Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3DZMvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:51:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:9035 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3DZMvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:51:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,558,1363158000"; 
   d="scan'208";a="326537214"
Subject: [PATCH V2] x86: eliminate irq_mis_count counted in arch_irq_stat
From: Li Fei <fei.li@intel.com>
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        chuansheng.liu@intel.com, tomoki.sekiyama.qu@hitachi.com,
        joe@perches.com, linux-kernel@vger.kernel.org, fei.li@intel.com
In-Reply-To: <1366962971.32469.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1366962971.32469.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Apr 2013 20:50:11 +0800
Message-ID: <1366980611.32469.7.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With current implementation, kstat_cpu(cpu).irqs_sum is also
increased in case of irq_mis_count increment.
So there is no need to count irq_mis_count in arch_irq_stat,
otherwise irq_mis_count will be counted twice in the sum of
/proc/stat.

Reported-by: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
Acked-by: Liu Chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/irq.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index e4595f1..84b7789 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -165,10 +165,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 u64 arch_irq_stat(void)
 {
 	u64 sum = atomic_read(&irq_err_count);
-
-#ifdef CONFIG_X86_IO_APIC
-	sum += atomic_read(&irq_mis_count);
-#endif
 	return sum;
 }
 
-- 
1.7.4.1



