Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab3EFXDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:03:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759213Ab3EFW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:59:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Chuansheng <chuansheng.liu@intel.com>, Li Fei <fei.li@intel.com>,
        Ingo Molnar <mingo@kernel.org>, tomoki.sekiyama.qu@hitachi.com,
        joe@perches.com
Subject: [ 42/46] x86: Eliminate irq_mis_count counted in arch_irq_stat
Date: Mon,  6 May 2013 15:58:48 -0700
Message-Id: <20130506225825.074956821@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/irq.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -159,10 +159,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 u64 arch_irq_stat(void)
 {
 	u64 sum = atomic_read(&irq_err_count);
-
-#ifdef CONFIG_X86_IO_APIC
-	sum += atomic_read(&irq_mis_count);
-#endif
 	return sum;
 }
 


