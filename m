Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3JTVH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:07:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:47881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3JTVHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,534,1378882800"; 
   d="scan'208";a="395837718"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rostedt@goodmis.org, peterz@infradead.org
Subject: [PATCH] perf: Allow ftracing perf code
Date: Sun, 20 Oct 2013 14:07:16 -0700
Message-Id: <1382303236-23839-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

According to Stephen there is no reason left not to allow
function trace in perf code.  Don't disable the function
tracer instrumentation for the perf files. Changes the
generic and the x86 files.

I've been using variants of this patch for a long time and
haven't seen any problems.  It's really useful to figure
out why a complex perf_event_open() syscall fails.

Cc: rostedt@goodmis.org
Cc: peterz@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile | 1 -
 kernel/events/Makefile       | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 47b56a7..190bf4a 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -5,7 +5,6 @@
 # Don't trace early stages of a secondary CPU boot
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o = -pg
-CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
 # Make sure load_percpu_segment has no stackprotector
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..a630994 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -1,7 +1,3 @@
-ifdef CONFIG_FUNCTION_TRACER
-CFLAGS_REMOVE_core.o = -pg
-endif
-
 obj-y := core.o ring_buffer.o callchain.o
 
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
-- 
1.8.3.1

