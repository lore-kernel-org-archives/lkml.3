Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaIJAtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:49:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:46506 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaIJAtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:49:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="383860698"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, x86: Add INTEL_FLAGS_UEVENT_CONSTRAINT
Date: Tue,  9 Sep 2014 17:49:07 -0700
Message-Id: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a FLAGS_UEVENT_CONSTRAINT macro that allows us to
match on event+umask, and in additional all flags.

This is needed to ensure the INV and CMASK fields
are zero for specific events, as this can cause undefined
behavior.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fc5eb39..4e6cdb0 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -253,6 +253,10 @@ struct cpu_hw_events {
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
 
+/* Like UEVENT_CONSTRAINT, but match flags too */
+#define INTEL_FLAGS_UEVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS)
+
 #define INTEL_PLD_CONSTRAINT(c, n)	\
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
-- 
1.9.3

