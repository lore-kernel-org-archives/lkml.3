Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab3GKO0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab3GKO0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jed Davis <jld@mozilla.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 30/98] ARM: 7765/1: perf: Record the user-mode PC in the call chain.
Date: Thu, 11 Jul 2013 15:24:00 +0100
Message-Id: <1373552708-15235-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jed Davis <jld@mozilla.com>

commit c5f927a6f62196226915f12194c9d0df4e2210d7 upstream.

With this change, we no longer lose the innermost entry in the user-mode
part of the call chain.  See also the x86 port, which includes the ip.

It's possible to partially work around this problem by post-processing
the data to use the PERF_SAMPLE_IP value, but this works only if the CPU
wasn't in the kernel when the sample was taken.

Signed-off-by: Jed Davis <jld@mozilla.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/perf_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 952a5a7..55790a5 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -824,6 +824,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	struct frame_tail __user *tail;
 
 
+	perf_callchain_store(entry, regs->ARM_pc);
 	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
 
 	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
-- 
1.8.1.2

