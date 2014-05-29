Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbaE2P1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:27:16 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60065 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016AbaE2P1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:27:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] perf/x86: Remove get_hbp_len and replace with bp_len
Date: Thu, 29 May 2014 17:26:53 +0200
Message-Id: <1401377213-24551-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.w.shin@gmail.com>

Clean up the logic for determining the breakpoint length

Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: xiakaixu <xiakaixu@huawei.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index fa24eb5..2a9000c 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -168,29 +168,6 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 		set_dr_addr_mask(0, i);
 }
 
-static int get_hbp_len(u8 hbp_len)
-{
-	unsigned int len_in_bytes = 0;
-
-	switch (hbp_len) {
-	case X86_BREAKPOINT_LEN_1:
-		len_in_bytes = 1;
-		break;
-	case X86_BREAKPOINT_LEN_2:
-		len_in_bytes = 2;
-		break;
-	case X86_BREAKPOINT_LEN_4:
-		len_in_bytes = 4;
-		break;
-#ifdef CONFIG_X86_64
-	case X86_BREAKPOINT_LEN_8:
-		len_in_bytes = 8;
-		break;
-#endif
-	}
-	return len_in_bytes;
-}
-
 /*
  * Check for virtual address in kernel space.
  */
@@ -201,7 +178,7 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 
 	va = info->address;
-	len = get_hbp_len(info->len);
+	len = bp->attr.bp_len;
 
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
-- 
1.8.3.1

