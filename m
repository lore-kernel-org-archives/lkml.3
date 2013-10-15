Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab3JOVEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:04:55 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:55762 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782Ab3JOVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:45 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/13] ARM: Disable jprobe selftests in thumb kernels
Date: Tue, 15 Oct 2013 17:04:24 -0400
Message-Id: <1381871068-27660-10-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

jprobe kernel selftests are not supported for thumb kernels. Conditionally
disable them in the kernel kprobes-test module.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/kernel/kprobes-test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 44a8a13..2144df1 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -358,6 +358,7 @@ static int test_kprobe(long (*func)(long, long))
 	return 0;
 }
 
+#ifndef CONFIG_THUMB2_KERNEL
 static void __kprobes jprobe_func(long r0, long r1)
 {
 	jprobe_func_called = test_func_instance;
@@ -401,6 +402,7 @@ static int test_jprobe(long (*func)(long, long))
 
 	return 0;
 }
+#endif
 
 static int __kprobes
 kretprobe_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
@@ -456,10 +458,12 @@ static int run_api_tests(long (*func)(long, long))
 	if (ret < 0)
 		return ret;
 
+#ifndef CONFIG_THUMB2_KERNEL
 	pr_info("    jprobe\n");
 	ret = test_jprobe(func);
 	if (ret < 0)
 		return ret;
+#endif
 
 	pr_info("    kretprobe\n");
 	ret = test_kretprobe(func);
-- 
1.8.1.2

