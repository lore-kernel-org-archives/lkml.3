Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab3E1D4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52610 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758941Ab3E1DyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        joe@perches.com, tomoki.sekiyama.qu@hitachi.com,
        "Liu Chuansheng" <chuansheng.liu@intel.com>,
        "Li Fei" <fei.li@intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.424837811@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [06/94] x86: Eliminate irq_mis_count counted in arch_irq_stat
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/irq.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -160,10 +160,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 u64 arch_irq_stat(void)
 {
 	u64 sum = atomic_read(&irq_err_count);
-
-#ifdef CONFIG_X86_IO_APIC
-	sum += atomic_read(&irq_mis_count);
-#endif
 	return sum;
 }
 

