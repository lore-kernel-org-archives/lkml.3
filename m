Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3ERDGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:06:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3ERDA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:27 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=B7sxqI1kCRAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mWrdSZvX5NEA:10 a=QyXUC8HyAAAA:8 a=3nbZYyFuAAAA:8 a=IJv9LcIfAAAA:8 a=VwQbUJbxAAAA:8 a=dMwd73gJPsQ3I164TsMA:9 a=dGJ0OcVc7YAA:10 a=EvKJbDF4Ut8A:10 a=K6kUPx8HyhEA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=gnIMjIGYad7w0yyp:21 a=XRwIk9VeLmo4OneP:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021654.813101863@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Liu Chuansheng <chuansheng.liu@intel.com>, Li Fei <fei.li@intel.com>,
        <tomoki.sekiyama.qu@hitachi.com>, <joe@perches.com>,
        <stable@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [ 081/136 ] x86: Eliminate irq_mis_count counted in arch_irq_stat
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0081-x86-Eliminate-irq_mis_count-counted-in-arch_irq_stat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Li Fei <fei.li@intel.com>

[ Upstream commit f7b0e1055574ce06ab53391263b4e205bf38daf3 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/irq.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d44f782..e62cf16 100644
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
1.7.10.4


