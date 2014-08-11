Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaHKFb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:31:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:20208 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaHKFbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="467286391"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 13/23] x86: Add Intel Processor Trace (INTEL_PT) cpu feature detection
Date: Mon, 11 Aug 2014 08:19:42 +0300
Message-Id: <1407734392-31097-14-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Processor Trace is an architecture extension that allows for program
flow tracing.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/kernel/cpu/scattered.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e265ff95d1..53710d028a 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -186,6 +186,7 @@
 #define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK (7*32+ 9) /* AMD ProcFeedbackInterface */
+#define X86_FEATURE_INTEL_PT	(7*32+10) /* Intel Processor Trace */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b6f794aa16..726e6a376b 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -36,6 +36,7 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
 		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006, 0 },
+		{ X86_FEATURE_INTEL_PT,		CR_EBX,25, 0x00000007, 0 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
-- 
2.1.0.rc1

