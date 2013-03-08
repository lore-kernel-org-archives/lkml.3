Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab3CHXYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:24:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:1310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab3CHXYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:24:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,810,1355126400"; 
   d="scan'208";a="267170866"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, rostedt@goodmis.org
Subject: [PATCH] perf: Enable function tracing for perf core
Date: Fri,  8 Mar 2013 15:24:46 -0800
Message-Id: <1362785086-12901-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

According to Steven R. there is no reason left to not support
function tracing for the perf core. This makes it easier to debug
perf.

Don't remove -pg for the x86 and generic perf core.

Cc: rostedt@goodmis.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile |    1 -
 kernel/events/Makefile       |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d..8eb5d28 100644
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
1.7.7.6

