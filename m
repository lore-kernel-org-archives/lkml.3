Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3IKQKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:10:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56854 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3IKQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:10:13 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 16/25] smp, s390: prepare for killing generic_smp_call_function_single_interrupt()
Date: Thu, 12 Sep 2013 00:07:20 +0800
Message-Id: <1378915649-16395-17-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/s390/kernel/smp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index d386c4e..81ca42a 100644
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

