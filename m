Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3ETLSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:18:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3ETKwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Fei <fei.li@intel.com>, tomoki.sekiyama.qu@hitachi.com, joe@perches.com,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 029/115] x86: Eliminate irq_mis_count counted in arch_irq_stat
Date: Mon, 20 May 2013 11:50:29 +0100
Message-Id: <1369047116-9378-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Fei <fei.li@intel.com>

commit f7b0e1055574ce06ab53391263b4e205bf38daf3 upstream.

With the current implementation, kstat_cpu(cpu).irqs_sum is also
increased in case of irq_mis_count increment.

So there is no need to count irq_mis_count in arch_irq_stat,
otherwise irq_mis_count will be counted twice in the sum of
/proc/stat.

Reported-by: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
Acked-by: Liu Chuansheng <chuansheng.liu@intel.com>
Cc: tomoki.sekiyama.qu@hitachi.com
Cc: joe@perches.com
Link: http://lkml.kernel.org/r/1366980611.32469.7.camel@fli24-HP-Compaq-8100-Elite-CMT-PC
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/irq.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3dafc60..a14a835 100644
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
1.8.1.2

