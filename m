Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3F1SyC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:54:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3F1Sx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:53:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jed Davis <jld@mozilla.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 062/105] perf: arm64: Record the user-mode PC in the call chain.
Date: Fri, 28 Jun 2013 11:51:24 -0700
Message-Id: <1372445527-24414-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jed Davis <jld@mozilla.com>

With this change, we no longer lose the innermost entry in the user-mode
part of the call chain.  See also the x86 port, which includes the ip,
and the corresponding change in arch/arm.

Signed-off-by: Jed Davis <jld@mozilla.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/perf_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index f7073c7..0256b68 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1331,6 +1331,7 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
 {
 	struct frame_tail __user *tail;
 
+	perf_callchain_store(entry, regs->pc);
 	tail = (struct frame_tail __user *)regs->regs[29];
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH &&
-- 
1.8.1.2

