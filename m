Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3DZOVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:21:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3DZOVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:21:05 -0400
Date: Fri, 26 Apr 2013 07:20:46 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        gorcunov@gmail.com, tytso@mit.edu, davem@davemloft.net,
        fweisbec@gmail.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, tytso@mit.edu,
        gorcunov@gmail.com, davem@davemloft.net, fweisbec@gmail.com,
        oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20130424072630.GB1780@gmail.com>
References: <20130424072630.GB1780@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/P4: Robistify P4 PMU types
Git-Commit-ID: 5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886
Gitweb:     http://git.kernel.org/tip/5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 24 Apr 2013 09:26:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Apr 2013 09:31:41 +0200

perf/x86/intel/P4: Robistify P4 PMU types

Linus found, while extending integer type extension checks in the
sparse static code checker, various fragile patterns of mixed
signed/unsigned  64-bit/32-bit integer use in perf_events_p4.c.

The relevant hardware register ABI is 64 bit wide on 32-bit
kernels as  well, so clean it all up a bit, remove unnecessary
casts, and make sure we  use 64-bit unsigned integers in these
places.

[ Unfortunately this patch was not tested on real P4 hardware,
  those are pretty rare already. If this patch causes any
  problems on P4 hardware then please holler ... ]

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130424072630.GB1780@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/perf_event_p4.h | 62 ++++++++++++++++++------------------
 arch/x86/kernel/cpu/perf_event_p4.c  |  9 +++---
 2 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 4f7e67e..85e13cc 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -24,45 +24,45 @@
 #define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
 #define ARCH_P4_UNFLAGGED_BIT	((1ULL) << (ARCH_P4_CNTRVAL_BITS - 1))
 
-#define P4_ESCR_EVENT_MASK	0x7e000000U
+#define P4_ESCR_EVENT_MASK	0x7e000000ULL
 #define P4_ESCR_EVENT_SHIFT	25
-#define P4_ESCR_EVENTMASK_MASK	0x01fffe00U
+#define P4_ESCR_EVENTMASK_MASK	0x01fffe00ULL
 #define P4_ESCR_EVENTMASK_SHIFT	9
-#define P4_ESCR_TAG_MASK	0x000001e0U
+#define P4_ESCR_TAG_MASK	0x000001e0ULL
 #define P4_ESCR_TAG_SHIFT	5
-#define P4_ESCR_TAG_ENABLE	0x00000010U
-#define P4_ESCR_T0_OS		0x00000008U
-#define P4_ESCR_T0_USR		0x00000004U
-#define P4_ESCR_T1_OS		0x00000002U
-#define P4_ESCR_T1_USR		0x00000001U
+#define P4_ESCR_TAG_ENABLE	0x00000010ULL
+#define P4_ESCR_T0_OS		0x00000008ULL
+#define P4_ESCR_T0_USR		0x00000004ULL
+#define P4_ESCR_T1_OS		0x00000002ULL
+#define P4_ESCR_T1_USR		0x00000001ULL
 
 #define P4_ESCR_EVENT(v)	((v) << P4_ESCR_EVENT_SHIFT)
 #define P4_ESCR_EMASK(v)	((v) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_TAG(v)		((v) << P4_ESCR_TAG_SHIFT)
 
-#define P4_CCCR_OVF			0x80000000U
-#define P4_CCCR_CASCADE			0x40000000U
-#define P4_CCCR_OVF_PMI_T0		0x04000000U
-#define P4_CCCR_OVF_PMI_T1		0x08000000U
-#define P4_CCCR_FORCE_OVF		0x02000000U
-#define P4_CCCR_EDGE			0x01000000U
-#define P4_CCCR_THRESHOLD_MASK		0x00f00000U
+#define P4_CCCR_OVF			0x80000000ULL
+#define P4_CCCR_CASCADE			0x40000000ULL
+#define P4_CCCR_OVF_PMI_T0		0x04000000ULL
+#define P4_CCCR_OVF_PMI_T1		0x08000000ULL
+#define P4_CCCR_FORCE_OVF		0x02000000ULL
+#define P4_CCCR_EDGE			0x01000000ULL
+#define P4_CCCR_THRESHOLD_MASK		0x00f00000ULL
 #define P4_CCCR_THRESHOLD_SHIFT		20
-#define P4_CCCR_COMPLEMENT		0x00080000U
-#define P4_CCCR_COMPARE			0x00040000U
-#define P4_CCCR_ESCR_SELECT_MASK	0x0000e000U
+#define P4_CCCR_COMPLEMENT		0x00080000ULL
+#define P4_CCCR_COMPARE			0x00040000ULL
+#define P4_CCCR_ESCR_SELECT_MASK	0x0000e000ULL
 #define P4_CCCR_ESCR_SELECT_SHIFT	13
-#define P4_CCCR_ENABLE			0x00001000U
-#define P4_CCCR_THREAD_SINGLE		0x00010000U
-#define P4_CCCR_THREAD_BOTH		0x00020000U
-#define P4_CCCR_THREAD_ANY		0x00030000U
-#define P4_CCCR_RESERVED		0x00000fffU
+#define P4_CCCR_ENABLE			0x00001000ULL
+#define P4_CCCR_THREAD_SINGLE		0x00010000ULL
+#define P4_CCCR_THREAD_BOTH		0x00020000ULL
+#define P4_CCCR_THREAD_ANY		0x00030000ULL
+#define P4_CCCR_RESERVED		0x00000fffULL
 
 #define P4_CCCR_THRESHOLD(v)		((v) << P4_CCCR_THRESHOLD_SHIFT)
 #define P4_CCCR_ESEL(v)			((v) << P4_CCCR_ESCR_SELECT_SHIFT)
 
 #define P4_GEN_ESCR_EMASK(class, name, bit)	\
-	class##__##name = ((1 << bit) << P4_ESCR_EVENTMASK_SHIFT)
+	class##__##name = ((1ULL << bit) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_EMASK_BIT(class, name)		class##__##name
 
 /*
@@ -107,7 +107,7 @@
  * P4_PEBS_CONFIG_MASK and related bits on
  * modification.)
  */
-#define P4_CONFIG_ALIASABLE		(1 << 9)
+#define P4_CONFIG_ALIASABLE		(1ULL << 9)
 
 /*
  * The bits we allow to pass for RAW events
@@ -784,17 +784,17 @@ enum P4_ESCR_EMASKS {
  * Note we have UOP and PEBS bits reserved for now
  * just in case if we will need them once
  */
-#define P4_PEBS_CONFIG_ENABLE		(1 << 7)
-#define P4_PEBS_CONFIG_UOP_TAG		(1 << 8)
-#define P4_PEBS_CONFIG_METRIC_MASK	0x3f
-#define P4_PEBS_CONFIG_MASK		0xff
+#define P4_PEBS_CONFIG_ENABLE		(1ULL << 7)
+#define P4_PEBS_CONFIG_UOP_TAG		(1ULL << 8)
+#define P4_PEBS_CONFIG_METRIC_MASK	0x3FLL
+#define P4_PEBS_CONFIG_MASK		0xFFLL
 
 /*
  * mem: Only counters MSR_IQ_COUNTER4 (16) and
  * MSR_IQ_COUNTER5 (17) are allowed for PEBS sampling
  */
-#define P4_PEBS_ENABLE			0x02000000U
-#define P4_PEBS_ENABLE_UOP_TAG		0x01000000U
+#define P4_PEBS_ENABLE			0x02000000ULL
+#define P4_PEBS_ENABLE_UOP_TAG		0x01000000ULL
 
 #define p4_config_unpack_metric(v)	(((u64)(v)) & P4_PEBS_CONFIG_METRIC_MASK)
 #define p4_config_unpack_pebs(v)	(((u64)(v)) & P4_PEBS_CONFIG_MASK)
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 92c7e39..3486e66 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -895,8 +895,8 @@ static void p4_pmu_disable_pebs(void)
 	 * So at moment let leave metrics turned on forever -- it's
 	 * ok for now but need to be revisited!
 	 *
-	 * (void)wrmsrl_safe(MSR_IA32_PEBS_ENABLE, (u64)0);
-	 * (void)wrmsrl_safe(MSR_P4_PEBS_MATRIX_VERT, (u64)0);
+	 * (void)wrmsrl_safe(MSR_IA32_PEBS_ENABLE, 0);
+	 * (void)wrmsrl_safe(MSR_P4_PEBS_MATRIX_VERT, 0);
 	 */
 }
 
@@ -910,8 +910,7 @@ static inline void p4_pmu_disable_event(struct perf_event *event)
 	 * asserted again and again
 	 */
 	(void)wrmsrl_safe(hwc->config_base,
-		(u64)(p4_config_unpack_cccr(hwc->config)) &
-			~P4_CCCR_ENABLE & ~P4_CCCR_OVF & ~P4_CCCR_RESERVED);
+		p4_config_unpack_cccr(hwc->config) & ~P4_CCCR_ENABLE & ~P4_CCCR_OVF & ~P4_CCCR_RESERVED);
 }
 
 static void p4_pmu_disable_all(void)
@@ -957,7 +956,7 @@ static void p4_pmu_enable_event(struct perf_event *event)
 	u64 escr_addr, cccr;
 
 	bind = &p4_event_bind_map[idx];
-	escr_addr = (u64)bind->escr_msr[thread];
+	escr_addr = bind->escr_msr[thread];
 
 	/*
 	 * - we dont support cascaded counters yet
