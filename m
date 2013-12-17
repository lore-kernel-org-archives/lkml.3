Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3LQNgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:36:05 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42774 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3LQNgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:36:04 -0500
Date: Tue, 17 Dec 2013 14:35:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix
Message-ID: <20131217133559.GA28957@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: cf30d52e2d11523c42048ab89ed4215b5021526a perf/x86: Fix constraint table end marker bug

An x86/intel event constraint fix.

 Thanks,

	Ingo

------------------>
Maria Dimakopoulou (1):
      perf/x86: Fix constraint table end marker bug


 arch/x86/kernel/cpu/perf_event.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fd00bb2..c1a8618 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -262,11 +262,20 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
-#define EVENT_CONSTRAINT_END		\
-	EVENT_CONSTRAINT(0, 0, 0)
+/*
+ * We define the end marker as having a weight of -1
+ * to enable blacklisting of events using a counter bitmask
+ * of zero and thus a weight of zero.
+ * The end marker has a weight that cannot possibly be
+ * obtained from counting the bits in the bitmask.
+ */
+#define EVENT_CONSTRAINT_END { .weight = -1 }
 
+/*
+ * Check for end marker with weight == -1
+ */
 #define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->weight; (e)++)
+	for ((e) = (c); (e)->weight != -1; (e)++)
 
 /*
  * Extra registers for specific events.
