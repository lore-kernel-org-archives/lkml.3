Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab3LDQSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:18:01 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47255 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab3LDQR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:17:57 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 13/19] smp, s390: prepare for killing generic_smp_call_function_single_interrupt()
Date: Thu,  5 Dec 2013 00:13:04 +0800
Message-Id: <1386173591-28514-14-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/s390/kernel/smp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index dc4a534..e550afd 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -49,7 +49,7 @@
 
 enum {
 	ec_schedule = 0,
-	ec_call_function_single,
+	ec_call_function,
 	ec_stop_cpu,
 };
 
@@ -437,8 +437,8 @@ static void smp_handle_ext_call(void)
 		smp_stop_cpu();
 	if (test_bit(ec_schedule, &bits))
 		scheduler_ipi();
-	if (test_bit(ec_call_function_single, &bits))
-		generic_smp_call_function_single_interrupt();
+	if (test_bit(ec_call_function, &bits))
+		generic_smp_call_function_interrupt();
 }
 
 static void do_ext_call_interrupt(struct ext_code ext_code,
@@ -453,12 +453,12 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 	int cpu;
 
 	for_each_cpu(cpu, mask)
-		pcpu_ec_call(pcpu_devices + cpu, ec_call_function_single);
+		pcpu_ec_call(pcpu_devices + cpu, ec_call_function);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	pcpu_ec_call(pcpu_devices + cpu, ec_call_function_single);
+	pcpu_ec_call(pcpu_devices + cpu, ec_call_function);
 }
 
 #ifndef CONFIG_64BIT
-- 
1.8.1.2

