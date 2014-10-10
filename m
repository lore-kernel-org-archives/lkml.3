Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaJJVsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:48:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:24682 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaJJVsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="586982389"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, rostedt@goodmis.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] perf, x86: Remove old MSR tracing code
Date: Fri, 10 Oct 2014 14:47:52 -0700
Message-Id: <1412977673-13500-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412977673-13500-1-git-send-email-andi@firstfloor.org>
References: <1412977673-13500-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now that we have generic MSR trace points we can remove the old
perf MSR trace code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8ade931..8e6cb95 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -14,17 +14,7 @@
 
 #include <linux/perf_event.h>
 
-#if 0
-#undef wrmsrl
-#define wrmsrl(msr, val) 						\
-do {									\
-	unsigned int _msr = (msr);					\
-	u64 _val = (val);						\
-	trace_printk("wrmsrl(%x, %Lx)\n", (unsigned int)(_msr),		\
-			(unsigned long long)(_val));			\
-	native_write_msr((_msr), (u32)(_val), (u32)(_val >> 32));	\
-} while (0)
-#endif
+/* To enable MSR tracing please use the generic trace points. */
 
 /*
  *          |   NHM/WSM    |      SNB     |
-- 
1.9.3

