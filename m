Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab3D3Qpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:45:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760898Ab3D3Qpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:45:40 -0400
Date: Tue, 30 Apr 2013 09:45:29 -0700
From: tip-bot for Li Fei <tipbot@zytor.com>
Message-ID: <tip-f7b0e1055574ce06ab53391263b4e205bf38daf3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@kernel.org, tglx@linutronix.de, chuansheng.liu@intel.com,
        fei.li@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, fei.li@intel.com,
        chuansheng.liu@intel.com
In-Reply-To: <1366980611.32469.7.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1366980611.32469.7.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86:
  Eliminate irq_mis_count counted in arch_irq_stat
Git-Commit-ID: f7b0e1055574ce06ab53391263b4e205bf38daf3
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

Commit-ID:  f7b0e1055574ce06ab53391263b4e205bf38daf3
Gitweb:     http://git.kernel.org/tip/f7b0e1055574ce06ab53391263b4e205bf38daf3
Author:     Li Fei <fei.li@intel.com>
AuthorDate: Fri, 26 Apr 2013 20:50:11 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 10:56:37 +0200

x86: Eliminate irq_mis_count counted in arch_irq_stat

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
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/irq.c | 4 ----
 1 file changed, 4 deletions(-)

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
 
